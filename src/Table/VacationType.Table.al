namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Absence;

table 50101 "Vacation Type"
{
    DataClassification = CustomerContent;
    Caption = 'Vacation Type';
    LookupPageId = "Vacation Type List";
    DrillDownPageId = "Vacation Type List";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Is Paid"; Boolean)
        {
            Caption = 'Paid Leave';
        }
        field(4; "Salary Pct"; Decimal)
        {
            Caption = 'Salary %';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 0 : 2;
        }
        field(5; "Count In Balance"; Boolean)
        {
            Caption = 'Count In Balance';
        }
        field(6; "Cause of Absence Code"; Code[10])
        {
            Caption = 'Cause of Absence Code';
            TableRelation = "Cause of Absence";
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}
