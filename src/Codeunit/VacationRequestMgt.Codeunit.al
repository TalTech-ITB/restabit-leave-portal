namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Absence;
using Microsoft.HumanResources.Employee;
using System.Utilities;

codeunit 50100 VacationRequestMgt
{
    procedure SubmitRequest(var VacReq: Record "Vacation Request")
    var
        ExistingReq: Record "Vacation Request";
        VacationType: Record "Vacation Type";
        Employee: Record Employee;
        UsedDays: Integer;
        Entitlement: Integer;
        YearStart: Date;
        YearEnd: Date;
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

        if VacationType.Get(VacReq."Vacation Type") and VacationType."Count In Balance" then begin
            Entitlement := 28;
            if Employee.Get(VacReq."Employee No.") then
                Entitlement := Employee."Annual Vacation Days";
            YearStart := DMY2Date(1, 1, Date2DMY(VacReq."From Date", 3));
            YearEnd := DMY2Date(31, 12, Date2DMY(VacReq."From Date", 3));
            ExistingReq.Reset();
            ExistingReq.SetRange("Employee No.", VacReq."Employee No.");
            ExistingReq.SetFilter("Entry No.", '<>%1', VacReq."Entry No.");
            ExistingReq.SetRange("Vacation Type", VacReq."Vacation Type");
            ExistingReq.SetFilter(Status, '%1|%2', VacationRequestStatus::Submitted, VacationRequestStatus::Approved);
            ExistingReq.SetFilter("From Date", '>=%1', YearStart);
            ExistingReq.SetFilter("To Date", '<=%1', YearEnd);
            if ExistingReq.FindSet() then
                repeat
                    UsedDays += ExistingReq."Total Days";
                until ExistingReq.Next() = 0;
            if UsedDays + VacReq."Total Days" > Entitlement then
                Error('Insufficient vacation balance. Entitlement: %1 day(s), used/pending: %2 day(s), requested: %3 day(s).',
                    Entitlement, UsedDays, VacReq."Total Days");
        end;

        VacReq.Status := VacationRequestStatus::Submitted;
        VacReq."Submitted At" := CurrentDateTime();
        VacReq.Modify(true);
        CreateNotification(GetManagerUserID(VacReq."Employee No."),
            CopyStr(StrSubstNo('New vacation request submitted by %1 (%2 – %3).',
                VacReq."Employee Name", VacReq."From Date", VacReq."To Date"), 1, 250),
            VacReq."Entry No.");
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
        CreateNotification(CopyStr(VacReq."User ID", 1, 50),
            CopyStr(StrSubstNo('Your vacation request (%1 – %2) has been approved by %3.',
                VacReq."From Date", VacReq."To Date", VacReq."Approved By"), 1, 250),
            VacReq."Entry No.");
    end;

    procedure RejectRequest(var VacReq: Record "Vacation Request")
    begin
        if VacReq.Status <> VacationRequestStatus::Submitted then
            Error('Only submitted requests can be rejected.');
        VacReq.Status := VacationRequestStatus::Rejected;
        VacReq."Rejected By" := CopyStr(UserId(), 1, MaxStrLen(VacReq."Rejected By"));
        VacReq."Rejected At" := CurrentDateTime();
        VacReq.Modify(true);
        CreateNotification(CopyStr(VacReq."User ID", 1, 50),
            CopyStr(StrSubstNo('Your vacation request (%1 – %2) has been rejected.',
                VacReq."From Date", VacReq."To Date"), 1, 250),
            VacReq."Entry No.");
    end;

    procedure CancelRequest(var VacReq: Record "Vacation Request")
    var
        WasSubmitted: Boolean;
    begin
        if (VacReq.Status <> VacationRequestStatus::Draft) and
           (VacReq.Status <> VacationRequestStatus::Submitted) then
            Error('Only draft or submitted requests can be cancelled.');
        WasSubmitted := VacReq.Status = VacationRequestStatus::Submitted;
        VacReq.Status := VacationRequestStatus::Cancelled;
        VacReq.Modify(true);
        if WasSubmitted then
            CreateNotification('',
                CopyStr(StrSubstNo('Vacation request for %1 (%2 – %3) has been cancelled.',
                    VacReq."Employee Name", VacReq."From Date", VacReq."To Date"), 1, 250),
                VacReq."Entry No.");
    end;

    procedure ExportToCalendar(VacReq: Record "Vacation Request")
    var
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        FileName: Text;
        Content: Text;
        CRLF: Text;
        CR: Char;
        LF: Char;
    begin
        if VacReq.Status <> VacationRequestStatus::Approved then
            Error('Only approved vacation requests can be exported to calendar.');

        CR := 13;
        LF := 10;
        CRLF := Format(CR) + Format(LF);

        Content :=
            'BEGIN:VCALENDAR' + CRLF +
            'VERSION:2.0' + CRLF +
            'PRODID:-//RestABit//Vacation Management//EN' + CRLF +
            'CALSCALE:GREGORIAN' + CRLF +
            'METHOD:PUBLISH' + CRLF +
            'BEGIN:VEVENT' + CRLF +
            'DTSTART;VALUE=DATE:' + Format(VacReq."From Date", 0, '<Year4><Month,2><Day,2>') + CRLF +
            'DTEND;VALUE=DATE:' + Format(VacReq."To Date" + 1, 0, '<Year4><Month,2><Day,2>') + CRLF +
            'SUMMARY:' + VacReq."Vacation Type" + ' - ' + VacReq."Employee Name" + CRLF +
            'DESCRIPTION:Approved vacation. Working days: ' + Format(VacReq."Total Days") + CRLF +
            'STATUS:CONFIRMED' + CRLF +
            'TRANSP:OPAQUE' + CRLF +
            'END:VEVENT' + CRLF +
            'END:VCALENDAR';

        TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
        OutStr.WriteText(Content);
        TempBlob.CreateInStream(InStr);

        FileName := 'Vacation_' + Format(VacReq."From Date", 0, '<Year4><Month,2><Day,2>') + '.ics';
        DownloadFromStream(InStr, '', '', 'Calendar Files (*.ics)|*.ics', FileName);
    end;

    local procedure GetManagerUserID(EmpNo: Code[20]): Code[50]
    var
        Emp: Record Employee;
    begin
        if Emp.Get(EmpNo) and (Emp."Manager User ID" <> '') then
            exit(Emp."Manager User ID");
        exit('');  // broadcast if no manager set
    end;

    local procedure CreateNotification(TargetUserID: Code[50]; Msg: Text[250]; RequestNo: Integer)
    var
        Notif: Record "Vacation Notification";
    begin
        Notif.Init();
        Notif."Target User ID" := TargetUserID;
        Notif.Message := Msg;
        Notif."Request No." := RequestNo;
        Notif."Created At" := CurrentDateTime();
        Notif."Is Read" := false;
        Notif.Insert(true);
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
