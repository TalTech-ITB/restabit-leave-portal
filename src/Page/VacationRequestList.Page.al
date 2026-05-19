namespace RestABit.VacationManagement;

page 50102 "Vacation Request List"
{
    PageType = List;
    SourceTable = "Vacation Request";
    Caption = 'Vacation Requests';
    CardPageId = "Vacation Request Card";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Vacation Type"; Rec."Vacation Type")
                {
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                }
                field("Total Days"; Rec."Total Days")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;
                }
                field("Submitted At"; Rec."Submitted At")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part(VacationBalance; "Vacation Balance FactBox")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Submit)
            {
                ApplicationArea = All;
                Caption = 'Submit';
                Enabled = CanSubmit;
                Image = SendApprovalRequest;

                trigger OnAction()
                var
                    VacReqMgt: Codeunit VacationRequestMgt;
                begin
                    VacReqMgt.SubmitRequest(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Enabled = CanApprove;
                Image = Approve;

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
                Enabled = CanReject;
                Image = Reject;

                trigger OnAction()
                var
                    VacReqMgt: Codeunit VacationRequestMgt;
                begin
                    VacReqMgt.RejectRequest(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            actionref(Submit_Ref; Submit) { }
            actionref(Approve_Ref; Approve) { }
            actionref(Reject_Ref; Reject) { }
        }
    }

    var
        CanSubmit: Boolean;
        CanApprove: Boolean;
        CanReject: Boolean;
        StatusStyle: Text;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.VacationBalance.PAGE.LoadData(Rec."Employee No.");
        CanSubmit := Rec.Status = VacationRequestStatus::Draft;
        CanApprove := Rec.Status = VacationRequestStatus::Submitted;
        CanReject := Rec.Status = VacationRequestStatus::Submitted;
        case Rec.Status of
            VacationRequestStatus::Approved:
                StatusStyle := 'Favorable';
            VacationRequestStatus::Rejected:
                StatusStyle := 'Unfavorable';
            VacationRequestStatus::Submitted:
                StatusStyle := 'Ambiguous';
            else
                StatusStyle := 'Standard';
        end;
    end;
}
