namespace RestABit.VacationManagement;

page 50111 "RestABit Demo Setup"
{
    PageType = Card;
    Caption = 'RestABit Demo Setup';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Instructions)
            {
                Caption = 'Instructions';
                label(Info)
                {
                    ApplicationArea = All;
                    Caption = 'Use the actions below to populate demo employees and sample vacation requests. Run "Create Employees" first, then "Create Requests".';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateEmployees)
            {
                ApplicationArea = All;
                Caption = 'Create Demo Employees';
                Image = Employee;
                ToolTip = 'Creates 8 sample employees across HR, IT, Finance, and Administration departments.';

                trigger OnAction()
                var
                    DemoData: Codeunit "RestABit Demo Data";
                begin
                    DemoData.CreateDemoEmployees();
                    Message('Demo employees created. Employees DEMO01–DEMO08 are now available.');
                end;
            }
            action(CreateRequests)
            {
                ApplicationArea = All;
                Caption = 'Create Demo Requests';
                Image = Absence;
                ToolTip = 'Creates sample vacation requests in various statuses (Draft, Submitted, Approved, Rejected).';

                trigger OnAction()
                var
                    DemoData: Codeunit "RestABit Demo Data";
                begin
                    DemoData.CreateDemoRequests();
                    Message('Demo vacation requests created.');
                end;
            }
        }
        area(Promoted)
        {
            actionref(CreateEmployees_Ref; CreateEmployees) { }
            actionref(CreateRequests_Ref; CreateRequests) { }
        }
    }
}
