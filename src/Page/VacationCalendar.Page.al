namespace RestABit.VacationManagement;

page 50108 "Vacation Calendar"
{
    PageType = List;
    SourceTable = "Vacation Request";
    Caption = 'Vacation Calendar';
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "Vacation Request Card";

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
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
                    ToolTip = 'Specifies the number of days.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee name.';
                }
                field("Vacation Type"; Rec."Vacation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of vacation.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;
                    ToolTip = 'Specifies the current status of the request.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who approved this request.';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies any notes on this request.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ThisWeek)
            {
                ApplicationArea = All;
                Caption = 'This Week';
                Image = DateRange;
                ToolTip = 'Show vacations overlapping with the current week.';

                trigger OnAction()
                var
                    WeekStart: Date;
                    WeekEnd: Date;
                begin
                    WeekStart := CalcDate('<-CW>', Today());
                    WeekEnd := CalcDate('<CW>', Today());
                    ApplyDateFilter(WeekStart, WeekEnd);
                end;
            }
            action(ThisMonth)
            {
                ApplicationArea = All;
                Caption = 'This Month';
                Image = DateRange;
                ToolTip = 'Show vacations overlapping with the current month.';

                trigger OnAction()
                var
                    MonthStart: Date;
                    MonthEnd: Date;
                begin
                    MonthStart := CalcDate('<-CM>', Today());
                    MonthEnd := CalcDate('<CM>', Today());
                    ApplyDateFilter(MonthStart, MonthEnd);
                end;
            }
            action(NextMonth)
            {
                ApplicationArea = All;
                Caption = 'Next Month';
                Image = DateRange;
                ToolTip = 'Show vacations overlapping with next month.';

                trigger OnAction()
                var
                    MonthStart: Date;
                    MonthEnd: Date;
                begin
                    MonthStart := CalcDate('<1M-CM>', Today());
                    MonthEnd := CalcDate('<1M+CM>', Today());
                    ApplyDateFilter(MonthStart, MonthEnd);
                end;
            }
            action(AllUpcoming)
            {
                ApplicationArea = All;
                Caption = 'All Upcoming';
                Image = DateRange;
                ToolTip = 'Show all upcoming and ongoing vacation requests.';

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetFilter(Status, '%1|%2',
                        VacationRequestStatus::Submitted, VacationRequestStatus::Approved);
                    Rec.SetFilter("To Date", '>=%1', Today());
                    Rec.SetCurrentKey("From Date");
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            actionref(ThisWeek_Ref; ThisWeek) { }
            actionref(ThisMonth_Ref; ThisMonth) { }
            actionref(NextMonth_Ref; NextMonth) { }
            actionref(AllUpcoming_Ref; AllUpcoming) { }
        }
    }

    var
        StatusStyle: Text;

    trigger OnOpenPage()
    begin
        Rec.SetFilter(Status, '%1|%2',
            VacationRequestStatus::Submitted, VacationRequestStatus::Approved);
        Rec.SetFilter("To Date", '>=%1', Today());
        Rec.SetCurrentKey("From Date");
    end;

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            VacationRequestStatus::Approved:
                StatusStyle := 'Favorable';
            VacationRequestStatus::Submitted:
                StatusStyle := 'Ambiguous';
            else
                StatusStyle := 'Standard';
        end;
    end;

    local procedure ApplyDateFilter(PeriodStart: Date; PeriodEnd: Date)
    begin
        Rec.Reset();
        Rec.SetFilter(Status, '%1|%2',
            VacationRequestStatus::Submitted, VacationRequestStatus::Approved);
        Rec.SetFilter("From Date", '<=%1', PeriodEnd);
        Rec.SetFilter("To Date", '>=%1', PeriodStart);
        Rec.SetCurrentKey("From Date");
        CurrPage.Update(false);
    end;
}
