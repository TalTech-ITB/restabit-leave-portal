namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Employee;

page 50107 "Team Vacation Overlap"
{
    PageType = ListPart;
    SourceTable = "Vacation Request";
    Caption = 'Team Schedule';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the employee.';
                }
                field("Vacation Type"; Rec."Vacation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of vacation.';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the start date.';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end date.';
                }
                field("Total Days"; Rec."Total Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total days.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;
                    ToolTip = 'Specifies the request status.';
                }
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            VacationRequestStatus::Approved:
                StatusStyle := 'Favorable';
            VacationRequestStatus::Submitted:
                StatusStyle := 'Ambiguous';
            else
                StatusStyle := 'Standard';
        end;
    end;

    procedure LoadData(EmpNo: Code[20]; FromDate: Date; ToDate: Date)
    var
        Employee: Record Employee;
        ColleagueEmp: Record Employee;
        EmpFilter: Text;
    begin
        Rec.Reset();

        if (EmpNo = '') or (FromDate = 0D) or (ToDate = 0D) then begin
            Rec.SetRange("Entry No.", -1);
            CurrPage.Update(false);
            exit;
        end;

        if not Employee.Get(EmpNo) then begin
            Rec.SetRange("Entry No.", -1);
            CurrPage.Update(false);
            exit;
        end;

        if Employee."Global Dimension 1 Code" = '' then begin
            Rec.SetFilter("Employee No.", '<>%1', EmpNo);
        end else begin
            ColleagueEmp.SetRange("Global Dimension 1 Code", Employee."Global Dimension 1 Code");
            ColleagueEmp.SetFilter("No.", '<>%1', EmpNo);
            if ColleagueEmp.FindSet() then
                repeat
                    if EmpFilter <> '' then
                        EmpFilter += '|';
                    EmpFilter += ColleagueEmp."No.";
                until ColleagueEmp.Next() = 0;

            if EmpFilter = '' then begin
                Rec.SetRange("Entry No.", -1);
                CurrPage.Update(false);
                exit;
            end;
            Rec.SetFilter("Employee No.", EmpFilter);
        end;

        Rec.SetFilter(Status, '%1|%2', VacationRequestStatus::Submitted, VacationRequestStatus::Approved);
        Rec.SetFilter("From Date", '<=%1', ToDate);
        Rec.SetFilter("To Date", '>=%1', FromDate);
        CurrPage.Update(false);
    end;
}
