namespace RestABit.VacationManagement;

codeunit 50102 "RestABit Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    begin
        FixCountInBalance();
    end;

    local procedure FixCountInBalance()
    var
        VacationType: Record "Vacation Type";
    begin
        if VacationType.Get('ANNUAL') then
            if not VacationType."Count In Balance" then begin
                VacationType."Count In Balance" := true;
                VacationType.Modify(false);
            end;
    end;
}
