namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Employee;

table 50100 "Vacation Request"
{
    DataClassification = CustomerContent;
    Caption = 'Vacation Request';
    LookupPageId = "Vacation Request List";
    DrillDownPageId = "Vacation Request List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;

            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Employee No.") then
                    "Employee Name" := CopyStr(Employee."First Name" + ' ' + Employee."Last Name", 1, MaxStrLen("Employee Name"))
                else
                    "Employee Name" := '';
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Vacation Type"; Code[20])
        {
            Caption = 'Vacation Type';
            TableRelation = "Vacation Type";
        }
        field(5; "From Date"; Date)
        {
            Caption = 'From Date';

            trigger OnValidate()
            begin
                CalcTotalDays();
            end;
        }
        field(6; "To Date"; Date)
        {
            Caption = 'To Date';

            trigger OnValidate()
            begin
                CalcTotalDays();
            end;
        }
        field(7; "Total Days"; Integer)
        {
            Caption = 'Total Days';
            Editable = false;
        }
        field(8; Status; Enum VacationRequestStatus)
        {
            Caption = 'Status';
            Editable = false;
        }
        field(9; "Submitted At"; DateTime)
        {
            Caption = 'Submitted At';
            Editable = false;
        }
        field(10; Notes; Text[250])
        {
            Caption = 'Notes';
        }
        field(11; "Rejection Reason"; Text[250])
        {
            Caption = 'Rejection Reason';
        }
        field(12; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(13; "Approved By"; Code[50])
        {
            Caption = 'Approved By';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(14; "Approved At"; DateTime)
        {
            Caption = 'Approved At';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(EmployeeDate; "Employee No.", "From Date") { }
        key(UserID; "User ID") { }
        key(FromDate; "From Date") { }
    }

    trigger OnInsert()
    begin
        "User ID" := CopyStr(UserId(), 1, MaxStrLen("User ID"));
    end;

    local procedure CalcTotalDays()
    begin
        if ("From Date" <> 0D) and ("To Date" <> 0D) and ("To Date" >= "From Date") then
            "Total Days" := "To Date" - "From Date" + 1
        else
            "Total Days" := 0;
    end;
}
