namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Absence;

permissionset 50100 "RestABit - All"
{
    Assignable = true;
    Caption = 'RestABit - All';

    Permissions =
        tabledata "Vacation Request" = RIMD,
        tabledata "Vacation Type" = RIMD,
        tabledata "Vacation Notification" = RIMD,
        tabledata "Public Holiday" = RIMD,
        tabledata "Employee Absence" = RIMD,
        table "Vacation Request" = X,
        table "Vacation Type" = X,
        table "Vacation Notification" = X,
        table "Public Holiday" = X,
        page "My Vacation Requests" = X,
        page "Vacation Pending Approvals" = X,
        page "Vacation Request List" = X,
        page "Vacation Request Card" = X,
        page "Vacation Type List" = X,
        page "Vacation Balance FactBox" = X,
        page "Team Vacation Overlap" = X,
        page "Vacation Calendar" = X,
        page "Vacation Notifications" = X,
        page "Public Holidays" = X,
        page "RestABit Activities" = X,
        page "RestABit Demo Setup" = X,
        codeunit VacationRequestMgt = X,
        codeunit "RestABit Demo Data" = X;
}
