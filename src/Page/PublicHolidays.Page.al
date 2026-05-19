namespace RestABit.VacationManagement;

page 50110 "Public Holidays"
{
    PageType = List;
    SourceTable = "Public Holiday";
    Caption = 'Public Holidays';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the public holiday.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the public holiday.';
                }
                field("Holiday Type"; Rec."Holiday Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Day Off: not counted as a working day in vacation requests. Higher Pay: counts as a working day but marks that elevated pay applies.';
                }
            }
        }
    }
}
