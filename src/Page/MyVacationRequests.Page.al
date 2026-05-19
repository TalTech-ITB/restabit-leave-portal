namespace RestABit.VacationManagement;

page 50105 "My Vacation Requests"
{
    PageType = List;
    SourceTable = "Vacation Request";
    Caption = 'My Vacation Requests';
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
                    ToolTip = 'Specifies the entry number of the vacation request.';
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the request.';
                    StyleExpr = StatusStyle;
                }
                field("Submitted At"; Rec."Submitted At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the request was submitted.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who approved this request.';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies any additional notes for this request.';
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
                ToolTip = 'Submit this vacation request for manager approval.';

                trigger OnAction()
                var
                    VacReqMgt: Codeunit VacationRequestMgt;
                begin
                    VacReqMgt.SubmitRequest(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            actionref(Submit_Ref; Submit) { }
        }
    }

    var
        CanSubmit: Boolean;
        StatusStyle: Text;

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", CopyStr(UserId(), 1, MaxStrLen(Rec."User ID")));
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.VacationBalance.PAGE.LoadData(Rec."Employee No.");
        CanSubmit := Rec.Status = VacationRequestStatus::Draft;
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
