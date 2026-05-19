namespace RestABit.VacationManagement;

table 50104 "Public Holiday"
{
    DataClassification = CustomerContent;
    Caption = 'Public Holiday';
    LookupPageId = "Public Holidays";
    DrillDownPageId = "Public Holidays";

    fields
    {
        field(1; Date; Date)
        {
            Caption = 'Date';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Holiday Type"; Enum PublicHolidayType)
        {
            Caption = 'Type';
        }
    }

    keys
    {
        key(PK; Date) { Clustered = true; }
        key(TypeDate; "Holiday Type", Date) { }
    }
}
