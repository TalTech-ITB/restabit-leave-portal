namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Employee;

codeunit 50101 "RestABit Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        SeedVacationTypes();
        InitEmployeeVacationDays();
    end;

    local procedure SeedVacationTypes()
    begin
        InsertType('ANNUAL', 'Annual Leave', true, 100, true, 'HOLIDAY');
        InsertType('SICK', 'Sick Leave (Day 4+)', true, 100, false, 'SICK');
        InsertType('SICK-1-3', 'Sick Leave (Days 1-3)', false, 0, false, 'SICK');
        InsertType('SICK-HALF', 'Sick Leave (Half Pay)', true, 50, false, 'SICK');
        InsertType('UNPAID', 'Unpaid Leave', false, 0, false, 'DAYOFF');
        InsertType('MATERNITY', 'Maternity Leave', true, 100, false, '');
        InsertType('PATERNITY', 'Paternity Leave', true, 100, false, '');
        InsertType('PARENTAL', 'Parental Leave', true, 70, false, '');
        InsertType('STUDY', 'Study / Exam Leave', true, 100, false, '');
        InsertType('BEREAVEMENT', 'Bereavement Leave', true, 100, false, '');
    end;

    local procedure InitEmployeeVacationDays()
    var
        Employee: Record Employee;
    begin
        Employee.SetRange("Annual Vacation Days", 0);
        if Employee.FindSet(true) then
            repeat
                Employee."Annual Vacation Days" := 28;
                Employee.Modify(false);
            until Employee.Next() = 0;
    end;

    local procedure InsertType(TypeCode: Code[20]; TypeDescription: Text[100]; IsPaid: Boolean; SalaryPct: Decimal; CountInBalance: Boolean; CauseCode: Code[10])
    var
        VacationType: Record "Vacation Type";
    begin
        if VacationType.Get(TypeCode) then
            exit;
        VacationType.Init();
        VacationType.Code := TypeCode;
        VacationType.Description := TypeDescription;
        VacationType."Is Paid" := IsPaid;
        VacationType."Salary Pct" := SalaryPct;
        VacationType."Count In Balance" := CountInBalance;
        VacationType."Cause of Absence Code" := CauseCode;
        VacationType.Insert(true);
    end;
}
