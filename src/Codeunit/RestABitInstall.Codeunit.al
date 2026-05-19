namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Employee;

codeunit 50101 "RestABit Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        SeedVacationTypes();
        InitEmployeeVacationDays();
        SeedEstonianHolidays();
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

    local procedure SeedEstonianHolidays()
    begin
        // 2025 — fixed holidays
        InsertHoliday(DMY2Date(1, 1, 2025), 'Uusaasta');
        InsertHoliday(DMY2Date(24, 2, 2025), 'Eesti Vabariigi aastapäev');
        InsertHoliday(DMY2Date(18, 4, 2025), 'Suur reede');
        InsertHoliday(DMY2Date(20, 4, 2025), 'Ülestõusmispühade 1. püha');
        InsertHoliday(DMY2Date(1, 5, 2025), 'Kevadpüha');
        InsertHoliday(DMY2Date(8, 6, 2025), 'Nelipühade 1. püha');
        InsertHoliday(DMY2Date(23, 6, 2025), 'Võidupüha');
        InsertHoliday(DMY2Date(24, 6, 2025), 'Jaanipäev');
        InsertHoliday(DMY2Date(20, 8, 2025), 'Taasiseseisvumispäev');
        InsertHoliday(DMY2Date(24, 12, 2025), 'Jõululaupäev');
        InsertHoliday(DMY2Date(25, 12, 2025), 'Esimene jõulupüha');
        InsertHoliday(DMY2Date(26, 12, 2025), 'Teine jõulupüha');

        // 2026
        InsertHoliday(DMY2Date(1, 1, 2026), 'Uusaasta');
        InsertHoliday(DMY2Date(24, 2, 2026), 'Eesti Vabariigi aastapäev');
        InsertHoliday(DMY2Date(3, 4, 2026), 'Suur reede');
        InsertHoliday(DMY2Date(5, 4, 2026), 'Ülestõusmispühade 1. püha');
        InsertHoliday(DMY2Date(1, 5, 2026), 'Kevadpüha');
        InsertHoliday(DMY2Date(24, 5, 2026), 'Nelipühade 1. püha');
        InsertHoliday(DMY2Date(23, 6, 2026), 'Võidupüha');
        InsertHoliday(DMY2Date(24, 6, 2026), 'Jaanipäev');
        InsertHoliday(DMY2Date(20, 8, 2026), 'Taasiseseisvumispäev');
        InsertHoliday(DMY2Date(24, 12, 2026), 'Jõululaupäev');
        InsertHoliday(DMY2Date(25, 12, 2026), 'Esimene jõulupüha');
        InsertHoliday(DMY2Date(26, 12, 2026), 'Teine jõulupüha');

        // 2027
        InsertHoliday(DMY2Date(1, 1, 2027), 'Uusaasta');
        InsertHoliday(DMY2Date(24, 2, 2027), 'Eesti Vabariigi aastapäev');
        InsertHoliday(DMY2Date(26, 3, 2027), 'Suur reede');
        InsertHoliday(DMY2Date(28, 3, 2027), 'Ülestõusmispühade 1. püha');
        InsertHoliday(DMY2Date(1, 5, 2027), 'Kevadpüha');
        InsertHoliday(DMY2Date(16, 5, 2027), 'Nelipühade 1. püha');
        InsertHoliday(DMY2Date(23, 6, 2027), 'Võidupüha');
        InsertHoliday(DMY2Date(24, 6, 2027), 'Jaanipäev');
        InsertHoliday(DMY2Date(20, 8, 2027), 'Taasiseseisvumispäev');
        InsertHoliday(DMY2Date(24, 12, 2027), 'Jõululaupäev');
        InsertHoliday(DMY2Date(25, 12, 2027), 'Esimene jõulupüha');
        InsertHoliday(DMY2Date(26, 12, 2027), 'Teine jõulupüha');
    end;

    local procedure InsertHoliday(HolidayDate: Date; HolidayDescription: Text[100])
    var
        PublicHoliday: Record "Public Holiday";
    begin
        if PublicHoliday.Get(HolidayDate) then
            exit;
        PublicHoliday.Init();
        PublicHoliday.Date := HolidayDate;
        PublicHoliday.Description := HolidayDescription;
        PublicHoliday."Holiday Type" := PublicHolidayType::DayOff;
        PublicHoliday.Insert(true);
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
