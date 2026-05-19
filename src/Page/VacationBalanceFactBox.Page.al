namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Employee;

page 50104 "Vacation Balance FactBox"
{
    PageType = ListPart;
    SourceTable = "Vacation Balance Line";
    SourceTableTemporary = true;
    Caption = 'Vacation Balance';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vacation type.';
                }
                field("Used This Year"; Rec."Used This Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many days have been approved this year.';
                }
                field(Entitlement; Rec.Entitlement)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the annual entitlement. 0 means no fixed limit.';
                }
                field(Remaining; Rec.Remaining)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies remaining days for types with a fixed entitlement.';
                    StyleExpr = RemainingStyle;
                }
            }
        }
    }

    var
        RemainingStyle: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec."Has Limit" then
            if Rec.Remaining <= 0 then
                RemainingStyle := 'Unfavorable'
            else if Rec.Remaining <= 5 then
                RemainingStyle := 'Ambiguous'
            else
                RemainingStyle := 'Favorable'
        else
            RemainingStyle := 'Standard';
    end;

    procedure LoadData(EmpNo: Code[20])
    var
        Employee: Record Employee;
        VacType: Record "Vacation Type";
        VacReq: Record "Vacation Request";
        YearStart: Date;
        YearEnd: Date;
        UsedDays: Integer;
        AnnualDays: Integer;
    begin
        Rec.DeleteAll();
        if EmpNo = '' then
            exit;

        AnnualDays := 28;
        if Employee.Get(EmpNo) then
            AnnualDays := Employee."Annual Vacation Days";

        YearStart := DMY2Date(1, 1, Date2DMY(Today, 3));
        YearEnd := DMY2Date(31, 12, Date2DMY(Today, 3));

        if VacType.FindSet() then
            repeat
                UsedDays := 0;
                VacReq.SetRange("Employee No.", EmpNo);
                VacReq.SetRange(Status, VacationRequestStatus::Approved);
                VacReq.SetRange("Vacation Type", VacType.Code);
                VacReq.SetFilter("From Date", '>=%1', YearStart);
                VacReq.SetFilter("To Date", '<=%1', YearEnd);
                if VacReq.FindSet() then
                    repeat
                        UsedDays += VacReq."Total Days";
                    until VacReq.Next() = 0;

                if (UsedDays > 0) or VacType."Count In Balance" then begin
                    Rec.Init();
                    Rec."Type Code" := VacType.Code;
                    Rec.Description := VacType.Description;
                    Rec."Used This Year" := UsedDays;
                    Rec."Has Limit" := VacType."Count In Balance";
                    if VacType."Count In Balance" then begin
                        Rec.Entitlement := AnnualDays;
                        Rec.Remaining := AnnualDays - UsedDays;
                    end;
                    Rec.Insert();
                end;
            until VacType.Next() = 0;

        CurrPage.Update(false);
    end;
}
