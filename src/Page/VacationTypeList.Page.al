namespace RestABit.VacationManagement;

page 50103 "Vacation Type List"
{
    PageType = List;
    SourceTable = "Vacation Type";
    Caption = 'Vacation Types';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique code for this vacation type.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the full name of the vacation type.';
                }
                field("Is Paid"; Rec."Is Paid")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the employee receives salary during this type of leave.';
                }
                field("Salary Pct"; Rec."Salary Pct")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the percentage of salary paid during this leave type.';
                }
                field("Count In Balance"; Rec."Count In Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether approved requests of this type are deducted from the employee''s annual vacation balance.';
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BC absence code to use when posting an approved request of this type to Employee Absences.';
                }
            }
        }
    }
}
