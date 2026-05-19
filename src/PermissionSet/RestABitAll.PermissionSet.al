namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Absence;

permissionset 50100 "RestABit - All"
{
    Assignable = true;
    Caption = 'RestABit - All';

    Permissions =
        tabledata "Vacation Request" = RIMD,
        tabledata "Vacation Type" = RIMD,
        tabledata "Employee Absence" = RIMD,
        table "Vacation Request" = X,
        table "Vacation Type" = X,
        page "My Vacation Requests" = X,
        page "Vacation Pending Approvals" = X,
        page "Vacation Request List" = X,
        page "Vacation Request Card" = X,
        page "Vacation Type List" = X,
        page "Vacation Balance FactBox" = X,
        page "Team Vacation Overlap" = X,
        page "Vacation Calendar" = X,
        codeunit VacationRequestMgt = X;
}
