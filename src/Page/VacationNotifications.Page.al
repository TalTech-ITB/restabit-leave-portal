namespace RestABit.VacationManagement;

page 50109 "Vacation Notifications"
{
    PageType = List;
    SourceTable = "Vacation Notification";
    Caption = 'My Notifications';
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Created At"; Rec."Created At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when this notification was created.';
                }
                field(Message; Rec.Message)
                {
                    ApplicationArea = All;
                    StyleExpr = MsgStyle;
                    ToolTip = 'Specifies the notification message.';
                }
                field("Is Read"; Rec."Is Read")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this notification has been read.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(MarkRead)
            {
                ApplicationArea = All;
                Caption = 'Mark as Read';
                Image = Approve;
                ToolTip = 'Mark the selected notification as read.';

                trigger OnAction()
                begin
                    Rec."Is Read" := true;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(MarkAllRead)
            {
                ApplicationArea = All;
                Caption = 'Mark All as Read';
                Image = ApproveAllLines;
                ToolTip = 'Mark all visible notifications as read.';

                trigger OnAction()
                var
                    Notif: Record "Vacation Notification";
                begin
                    Notif.Copy(Rec);
                    if Notif.FindSet(true) then
                        repeat
                            Notif."Is Read" := true;
                            Notif.Modify(false);
                        until Notif.Next() = 0;
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            actionref(MarkRead_Ref; MarkRead) { }
            actionref(MarkAllRead_Ref; MarkAllRead) { }
        }
    }

    var
        MsgStyle: Text;

    trigger OnOpenPage()
    var
        CurrentUser: Code[50];
    begin
        CurrentUser := CopyStr(UserId(), 1, MaxStrLen(CurrentUser));
        Rec.SetFilter("Target User ID", '%1|%2', CurrentUser, '');
        Rec.SetCurrentKey("Created At");
        Rec.Ascending(false);
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Is Read" then
            MsgStyle := 'Subordinate'
        else
            MsgStyle := 'Strong';
    end;
}
