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
            Caption = 'Working Days';
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
        field(15; "Rejected By"; Code[50])
        {
            Caption = 'Rejected By';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(16; "Rejected At"; DateTime)
        {
            Caption = 'Rejected At';
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
    var
        CurrentDate: Date;
    begin
        "Total Days" := 0;
        if ("From Date" = 0D) or ("To Date" = 0D) or ("To Date" < "From Date") then
            exit;
        CurrentDate := "From Date";
        while CurrentDate <= "To Date" do begin
            if (Date2DWY(CurrentDate, 1) <= 5) and not IsDayOffHoliday(CurrentDate) then
                "Total Days" += 1;
            CurrentDate := CalcDate('<+1D>', CurrentDate);
        end;
    end;

    local procedure IsDayOffHoliday(CheckDate: Date): Boolean
    var
        PublicHoliday: Record "Public Holiday";
    begin
        if PublicHoliday.Get(CheckDate) then
            exit(PublicHoliday."Holiday Type" = PublicHolidayType::DayOff);
        exit(false);
    end;
}
