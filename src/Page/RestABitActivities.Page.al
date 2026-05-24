namespace RestABit.VacationManagement;

page 50112 "RestABit Activities"
{
    PageType = Card;
    Caption = 'Vacation Overview';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            cuegroup(Approvals)
            {
                Caption = 'Approvals';

                field(PendingApprovals; PendingApprovalCount)
                {
                    ApplicationArea = All;
                    Caption = 'Pending Approvals';
                    StyleExpr = PendingStyle;
                    ToolTip = 'Number of vacation requests waiting for approval.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Vacation Pending Approvals");
                    end;
                }
                field(TeamAbsent; TeamAbsentCount)
                {
                    ApplicationArea = All;
                    Caption = 'Team Out Today';
                    ToolTip = 'Number of colleagues on approved vacation today.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Vacation Calendar");
                    end;
                }
            }
            cuegroup(MyActivity)
            {
                Caption = 'My Activity';

                field(MyDrafts; MyDraftCount)
                {
                    ApplicationArea = All;
                    Caption = 'My Drafts';
                    ToolTip = 'Number of your vacation requests still in draft.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"My Vacation Requests");
                    end;
                }
                field(MySubmitted; MySubmittedCount)
                {
                    ApplicationArea = All;
                    Caption = 'Awaiting Approval';
                    StyleExpr = SubmittedStyle;
                    ToolTip = 'Number of your vacation requests waiting for a manager decision.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"My Vacation Requests");
                    end;
                }
                field(UnreadNotif; UnreadNotifCount)
                {
                    ApplicationArea = All;
                    Caption = 'Unread Notifications';
                    StyleExpr = NotifStyle;
                    ToolTip = 'Number of unread vacation notifications.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Vacation Notifications");
                    end;
                }
            }
        }
    }

    var
        PendingApprovalCount: Integer;
        TeamAbsentCount: Integer;
        MyDraftCount: Integer;
        MySubmittedCount: Integer;
        UnreadNotifCount: Integer;
        PendingStyle: Text;
        SubmittedStyle: Text;
        NotifStyle: Text;

    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                ToolTip = 'Refresh all counts.';

                trigger OnAction()
                begin
                    RefreshCues();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            actionref(Refresh_Ref; Refresh) { }
        }
    }

    trigger OnOpenPage()
    begin
        RefreshCues();
    end;

    local procedure RefreshCues()
    var
        VacReq: Record "Vacation Request";
        Notif: Record "Vacation Notification";
        CurrentUser: Code[50];
    begin
        CurrentUser := CopyStr(UserId(), 1, MaxStrLen(CurrentUser));

        VacReq.SetRange(Status, VacationRequestStatus::Submitted);
        PendingApprovalCount := VacReq.Count();

        VacReq.Reset();
        VacReq.SetRange(Status, VacationRequestStatus::Approved);
        VacReq.SetFilter("From Date", '<=%1', Today());
        VacReq.SetFilter("To Date", '>=%1', Today());
        TeamAbsentCount := VacReq.Count();

        VacReq.Reset();
        VacReq.SetRange("User ID", CurrentUser);
        VacReq.SetRange(Status, VacationRequestStatus::Draft);
        MyDraftCount := VacReq.Count();

        VacReq.Reset();
        VacReq.SetRange("User ID", CurrentUser);
        VacReq.SetRange(Status, VacationRequestStatus::Submitted);
        MySubmittedCount := VacReq.Count();

        Notif.SetFilter("Target User ID", '%1|%2', CurrentUser, '');
        Notif.SetRange("Is Read", false);
        UnreadNotifCount := Notif.Count();

        if PendingApprovalCount > 0 then PendingStyle := 'Attention' else PendingStyle := 'Favorable';
        if MySubmittedCount > 0 then SubmittedStyle := 'Ambiguous' else SubmittedStyle := 'Standard';
        if UnreadNotifCount > 0 then NotifStyle := 'Attention' else NotifStyle := 'Standard';
    end;
}
