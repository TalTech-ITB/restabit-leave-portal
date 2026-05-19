namespace RestABit.VacationManagement;

page 50101 "Vacation Request Card"
{
    PageType = Card;
    SourceTable = "Vacation Request";
    Caption = 'Vacation Request';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Vacation Type"; Rec."Vacation Type")
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
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
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                    MultiLine = true;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    Visible = Rec.Status = VacationRequestStatus::Approved;
                    ToolTip = 'Specifies who approved this request.';
                }
                field("Approved At"; Rec."Approved At")
                {
                    ApplicationArea = All;
                    Visible = Rec.Status = VacationRequestStatus::Approved;
                    ToolTip = 'Specifies when this request was approved.';
                }
                field("Rejection Reason"; Rec."Rejection Reason")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                    Visible = Rec.Status = VacationRequestStatus::Rejected;
                    ToolTip = 'Specifies the reason this request was rejected.';
                }
                field("Rejected By"; Rec."Rejected By")
                {
                    ApplicationArea = All;
                    Visible = Rec.Status = VacationRequestStatus::Rejected;
                    ToolTip = 'Specifies who rejected this request.';
                }
                field("Rejected At"; Rec."Rejected At")
                {
                    ApplicationArea = All;
                    Visible = Rec.Status = VacationRequestStatus::Rejected;
                    ToolTip = 'Specifies when this request was rejected.';
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
                    CurrPage.SaveRecord();
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
            action(Cancel)
            {
                ApplicationArea = All;
                Caption = 'Cancel Request';
                Enabled = CanCancel;
                Image = Cancel;
                ToolTip = 'Cancel this vacation request.';

                trigger OnAction()
                var
                    VacReqMgt: Codeunit VacationRequestMgt;
                begin
                    VacReqMgt.CancelRequest(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            actionref(Submit_Ref; Submit) { }
            actionref(Approve_Ref; Approve) { }
            actionref(Reject_Ref; Reject) { }
            actionref(Cancel_Ref; Cancel) { }
        }
    }

    var
        IsEditable: Boolean;
        CanSubmit: Boolean;
        CanApprove: Boolean;
        CanReject: Boolean;
        CanCancel: Boolean;
        StatusStyle: Text;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControls();
        CurrPage.VacationBalance.PAGE.LoadData(Rec."Employee No.");
        CurrPage.TeamOverlap.PAGE.LoadData(Rec."Employee No.", Rec."From Date", Rec."To Date");
    end;

    local procedure UpdateControls()
    begin
        IsEditable := Rec.Status = VacationRequestStatus::Draft;
        CanSubmit := Rec.Status = VacationRequestStatus::Draft;
        CanApprove := Rec.Status = VacationRequestStatus::Submitted;
        CanReject := Rec.Status = VacationRequestStatus::Submitted;
        CanCancel := Rec.Status in [VacationRequestStatus::Draft, VacationRequestStatus::Submitted];
        case Rec.Status of
            VacationRequestStatus::Approved:
                StatusStyle := 'Favorable';
            VacationRequestStatus::Rejected:
                StatusStyle := 'Unfavorable';
            VacationRequestStatus::Submitted:
                StatusStyle := 'Ambiguous';
            VacationRequestStatus::Cancelled:
                StatusStyle := 'Subordinate';
            else
                StatusStyle := 'Standard';
        end;
    end;
}
