namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Employee;

pageextension 50101 "Employee Card Ext" extends "Employee Card"
{
    layout
    {
        addlast(Administration)
        {
            field("Annual Vacation Days"; Rec."Annual Vacation Days")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of annual vacation days this employee is entitled to.';
            }
            field("Manager User ID"; Rec."Manager User ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the BC login name of the manager. Auto-filled when Manager No. is set if the manager has existing vacation requests.';
            }
        }
        addlast(factboxes)
        {
            part(VacationBalance; "Vacation Balance FactBox")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast("E&mployee")
        {
            action(VacationRequests)
            {
                ApplicationArea = All;
                Caption = 'Vacation Requests';
                Image = Absence;
                RunObject = Page "Vacation Request List";
                RunPageLink = "Employee No." = field("No.");
                ToolTip = 'View all vacation requests for this employee.';
            }
        }
        addlast(Promoted)
        {
            actionref(VacationRequests_Ref; VacationRequests) { }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.VacationBalance.PAGE.LoadData(Rec."No.");
    end;
}
