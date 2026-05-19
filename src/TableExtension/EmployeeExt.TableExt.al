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
    }
}
