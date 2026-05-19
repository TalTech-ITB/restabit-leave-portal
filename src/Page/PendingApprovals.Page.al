namespace RestABit.VacationManagement;

page 50106 "Vacation Pending Approvals"
{
    PageType = List;
    SourceTable = "Vacation Request";
    Caption = 'Pending Vacation Approvals';
    CardPageId = "Vacation Request Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number of the vacation request.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee number.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the employee.';
                }
                field("Vacation Type"; Rec."Vacation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of vacation leave.';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the start date of the vacation.';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end date of the vacation.';
                }
                field("Total Days"; Rec."Total Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of calendar days.';
                }
                field("Submitted At"; Rec."Submitted At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the request was submitted.';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies any additional notes from the employee.';
                }
                field("Rejection Reason"; Rec."Rejection Reason")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the reason for rejecting this request. Fill in before clicking Reject.';
                }
            }
        }
        area(FactBoxes)
        {
            part(VacationBalance; "Vacation Balance FactBox")
            {
                ApplicationArea = All;
            }
            part(TeamOverlap; "Team Vacation Overlap")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                ToolTip = 'Approve this vacation request.';

                trigger OnAction()
                var
                    VacReqMgt: Codeunit VacationRequestMgt;
                begin
                    VacReqMgt.ApproveRequest(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                ToolTip = 'Reject this vacation request.';

                trigger OnAction()
                var
                    VacReqMgt: Codeunit VacationRequestMgt;
                begin
                    VacReqMgt.RejectRequest(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(Notifications)
            {
                ApplicationArea = All;
                Caption = 'My Notifications';
                Image = Alerts;
                ToolTip = 'View your vacation notifications.';
                RunObject = Page "Vacation Notifications";
            }
        }
        area(Promoted)
        {
            actionref(Approve_Ref; Approve) { }
            actionref(Reject_Ref; Reject) { }
            actionref(Notifications_Ref; Notifications) { }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Status, VacationRequestStatus::Submitted);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.VacationBalance.PAGE.LoadData(Rec."Employee No.");
        CurrPage.TeamOverlap.PAGE.LoadData(Rec."Employee No.", Rec."From Date", Rec."To Date");
    end;
}
