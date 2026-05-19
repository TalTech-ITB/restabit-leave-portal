namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Employee;

tableextension 50100 "Employee Ext" extends Employee
{
    fields
    {
        field(50100; "Annual Vacation Days"; Integer)
        {
            Caption = 'Annual Vacation Days';
            MinValue = 0;
            InitValue = 28;
        }
        field(50101; "Manager No."; Code[20])
        {
            Caption = 'Manager No.';
            TableRelation = Employee;

            trigger OnValidate()
            var
                ManagerReq: Record "Vacation Request";
            begin
                if "Manager No." = '' then begin
                    "Manager User ID" := '';
                    exit;
                end;
                ManagerReq.SetRange("Employee No.", "Manager No.");
                ManagerReq.SetFilter("User ID", '<>%1', '');
                if ManagerReq.FindFirst() then
                    "Manager User ID" := ManagerReq."User ID";
            end;
        }
        field(50102; "Manager User ID"; Code[50])
        {
            Caption = 'Manager User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
    }
}
