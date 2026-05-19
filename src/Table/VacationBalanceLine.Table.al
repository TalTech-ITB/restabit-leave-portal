namespace RestABit.VacationManagement;

table 50102 "Vacation Balance Line"
{
    TableType = Temporary;
    Caption = 'Vacation Balance Line';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Type Code"; Code[20]) { Caption = 'Type'; }
        field(2; Description; Text[100]) { Caption = 'Description'; }
        field(3; "Used This Year"; Integer) { Caption = 'Used'; }
        field(4; Entitlement; Integer) { Caption = 'Entitlement'; }
        field(5; Remaining; Integer) { Caption = 'Remaining'; }
        field(6; "Has Limit"; Boolean) { Caption = 'Has Limit'; }
    }

    keys
    {
        key(PK; "Type Code") { Clustered = true; }
    }
}
