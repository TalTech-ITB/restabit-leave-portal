namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Absence;

codeunit 50100 VacationRequestMgt
{
    procedure SubmitRequest(var VacReq: Record "Vacation Request")
    var
        ExistingReq: Record "Vacation Request";
    begin
        VacReq.TestField("Employee No.");
        VacReq.TestField("Vacation Type");
        VacReq.TestField("From Date");
        VacReq.TestField("To Date");
        if VacReq."To Date" < VacReq."From Date" then
            Error('To Date must be on or after From Date.');

        ExistingReq.SetRange("Employee No.", VacReq."Employee No.");
        ExistingReq.SetFilter("Entry No.", '<>%1', VacReq."Entry No.");
        ExistingReq.SetFilter(Status, '%1|%2', VacationRequestStatus::Submitted, VacationRequestStatus::Approved);
        ExistingReq.SetFilter("From Date", '<=%1', VacReq."To Date");
        ExistingReq.SetFilter("To Date", '>=%1', VacReq."From Date");
        if ExistingReq.FindFirst() then
            if not Confirm('You already have an overlapping vacation request (%1 – %2, %3). Do you still want to submit?',
                true, ExistingReq."From Date", ExistingReq."To Date", ExistingReq."Vacation Type")
            then
                exit;

        VacReq.Status := VacationRequestStatus::Submitted;
        VacReq."Submitted At" := CurrentDateTime();
        VacReq.Modify(true);
    end;

    procedure ApproveRequest(var VacReq: Record "Vacation Request")
    begin
        if VacReq.Status <> VacationRequestStatus::Submitted then
            Error('Only submitted requests can be approved.');
        VacReq.Status := VacationRequestStatus::Approved;
        VacReq."Approved By" := CopyStr(UserId(), 1, MaxStrLen(VacReq."Approved By"));
        VacReq."Approved At" := CurrentDateTime();
        VacReq.Modify(true);
        CreateAbsenceEntry(VacReq);
    end;

    procedure RejectRequest(var VacReq: Record "Vacation Request")
    begin
        if VacReq.Status <> VacationRequestStatus::Submitted then
            Error('Only submitted requests can be rejected.');
        VacReq.Status := VacationRequestStatus::Rejected;
        VacReq.Modify(true);
    end;

    [TryFunction]
    local procedure CreateAbsenceEntry(VacReq: Record "Vacation Request")
    var
        EmployeeAbsence: Record "Employee Absence";
        VacationType: Record "Vacation Type";
    begin
        if not VacationType.Get(VacReq."Vacation Type") then
            exit;
        if VacationType."Cause of Absence Code" = '' then
            exit;
        EmployeeAbsence.Init();
        EmployeeAbsence."Employee No." := VacReq."Employee No.";
        EmployeeAbsence."From Date" := VacReq."From Date";
        EmployeeAbsence."To Date" := VacReq."To Date";
        EmployeeAbsence."Cause of Absence Code" := VacationType."Cause of Absence Code";
        EmployeeAbsence.Quantity := VacReq."Total Days";
        EmployeeAbsence."Unit of Measure Code" := 'DAY';
        EmployeeAbsence.Insert(true);
    end;
}
