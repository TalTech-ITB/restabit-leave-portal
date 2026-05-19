namespace RestABit.VacationManagement;

codeunit 50102 "RestABit Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    begin
        FixCountInBalance();
        RecalcDraftWorkingDays();
        SeedEstonianHolidays();
    end;

    local procedure RecalcDraftWorkingDays()
    var
        VacReq: Record "Vacation Request";
    begin
        VacReq.SetRange(Status, VacationRequestStatus::Draft);
        if VacReq.FindSet(true) then
            repeat
                VacReq.Validate("To Date");
                VacReq.Modify(false);
            until VacReq.Next() = 0;
    end;

    local procedure SeedEstonianHolidays()
    begin
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
