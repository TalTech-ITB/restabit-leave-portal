namespace RestABit.VacationManagement;

table 50103 "Vacation Notification"
{
    DataClassification = CustomerContent;
    Caption = 'Vacation Notification';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Target User ID"; Code[50])
        {
            Caption = 'Target User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(3; Message; Text[250])
        {
            Caption = 'Message';
        }
        field(4; "Request No."; Integer)
        {
            Caption = 'Request No.';
        }
        field(5; "Created At"; DateTime)
        {
            Caption = 'Created At';
            Editable = false;
        }
        field(6; "Is Read"; Boolean)
        {
            Caption = 'Read';
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(UserRead; "Target User ID", "Is Read", "Created At") { }
    }
}
