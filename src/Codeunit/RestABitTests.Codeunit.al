namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Employee;

codeunit 50104 "RestABit Tests"
{
    Subtype = Test;

    // ── CalcTotalDays ────────────────────────────────────────────────────────

    [Test]
    procedure CalcTotalDays_FullWeek_Returns5()
    var
        VacReq: Record "Vacation Request";
    begin
        // Mon 2026-06-01 to Fri 2026-06-05 = 5 working days
        VacReq.Init();
        VacReq."From Date" := DMY2Date(1, 6, 2026);
        VacReq.Validate("To Date", DMY2Date(5, 6, 2026));
        AssertEqual(5, VacReq."Total Days", 'Mon–Fri should be 5 working days');
    end;

    [Test]
    procedure CalcTotalDays_IncludesWeekend_SkipsIt()
    var
        VacReq: Record "Vacation Request";
    begin
        // Mon 2026-06-01 to Mon 2026-06-08 spans a weekend → 6 working days
        VacReq.Init();
        VacReq."From Date" := DMY2Date(1, 6, 2026);
        VacReq.Validate("To Date", DMY2Date(8, 6, 2026));
        AssertEqual(6, VacReq."Total Days", 'Mon–Mon over weekend should be 6 working days');
    end;

    [Test]
    procedure CalcTotalDays_ToDateBeforeFromDate_ReturnsZero()
    var
        VacReq: Record "Vacation Request";
    begin
        VacReq.Init();
        VacReq."From Date" := DMY2Date(10, 6, 2026);
        VacReq.Validate("To Date", DMY2Date(5, 6, 2026));
        AssertEqual(0, VacReq."Total Days", 'To Date before From Date should give 0');
    end;

    [Test]
    procedure CalcTotalDays_PublicHoliday_SkipsIt()
    var
        VacReq: Record "Vacation Request";
        Holiday: Record "Public Holiday";
    begin
        // Mon 2026-06-01 to Fri 2026-06-05, add Wed as Day Off → 4 working days
        if not Holiday.Get(DMY2Date(3, 6, 2026)) then begin
            Holiday.Init();
            Holiday.Date := DMY2Date(3, 6, 2026);
            Holiday.Description := 'Test Holiday';
            Holiday."Holiday Type" := PublicHolidayType::DayOff;
            Holiday.Insert(false);
        end;

        VacReq.Init();
        VacReq."From Date" := DMY2Date(1, 6, 2026);
        VacReq.Validate("To Date", DMY2Date(5, 6, 2026));
        AssertEqual(4, VacReq."Total Days", 'Day Off holiday should reduce working days by 1');

        Holiday.Delete(false);
    end;

    [Test]
    procedure CalcTotalDays_HigherPayHoliday_CountsIt()
    var
        VacReq: Record "Vacation Request";
        Holiday: Record "Public Holiday";
    begin
        // Higher Pay holiday still counts as a working day
        if not Holiday.Get(DMY2Date(3, 6, 2026)) then begin
            Holiday.Init();
            Holiday.Date := DMY2Date(3, 6, 2026);
            Holiday.Description := 'Test Higher Pay';
            Holiday."Holiday Type" := PublicHolidayType::HigherPay;
            Holiday.Insert(false);
        end;

        VacReq.Init();
        VacReq."From Date" := DMY2Date(1, 6, 2026);
        VacReq.Validate("To Date", DMY2Date(5, 6, 2026));
        AssertEqual(5, VacReq."Total Days", 'Higher Pay holiday should still count as working day');

        Holiday.Delete(false);
    end;

    // ── SubmitRequest ────────────────────────────────────────────────────────

    [Test]
    procedure SubmitRequest_MissingEmployeeNo_Errors()
    var
        VacReq: Record "Vacation Request";
        Mgt: Codeunit VacationRequestMgt;
    begin
        CreateMinimalRequest(VacReq);
        VacReq."Employee No." := '';
        asserterror Mgt.SubmitRequest(VacReq);
    end;

    [Test]
    procedure SubmitRequest_ToDateBeforeFromDate_Errors()
    var
        VacReq: Record "Vacation Request";
        Mgt: Codeunit VacationRequestMgt;
    begin
        CreateMinimalRequest(VacReq);
        VacReq."To Date" := VacReq."From Date" - 1;
        asserterror Mgt.SubmitRequest(VacReq);
    end;

    [Test]
    procedure SubmitRequest_ValidRequest_SetsStatusAndTimestamp()
    var
        VacReq: Record "Vacation Request";
        Mgt: Codeunit VacationRequestMgt;
    begin
        CreateMinimalRequest(VacReq);
        Mgt.SubmitRequest(VacReq);
        AssertEqual(VacationRequestStatus::Submitted.AsInteger(), VacReq.Status.AsInteger(), 'Status should be Submitted');
        if VacReq."Submitted At" = 0DT then
            Error('Submitted At should be set after submit');
    end;

    [Test]
    procedure SubmitRequest_BalanceExceeded_Errors()
    var
        VacReq: Record "Vacation Request";
        VacType: Record "Vacation Type";
        Emp: Record Employee;
        Mgt: Codeunit VacationRequestMgt;
    begin
        // Employee with 5 days entitlement requesting 10 days
        InsertTestEmployee(Emp, 'TST-BAL', 5);
        InsertTestVacationType(VacType, 'TST-BAL', true);

        VacReq.Init();
        VacReq."Employee No." := Emp."No.";
        VacReq."Vacation Type" := VacType.Code;
        VacReq."From Date" := DMY2Date(1, 7, 2026);
        VacReq.Validate("To Date", DMY2Date(14, 7, 2026));  // 10 working days
        VacReq.Insert(false);

        asserterror Mgt.SubmitRequest(VacReq);

        VacReq.Delete(false);
        Emp.Delete(false);
        VacType.Delete(false);
    end;

    // ── ApproveRequest ───────────────────────────────────────────────────────

    [Test]
    procedure ApproveRequest_SetsApprovedByAndAt()
    var
        VacReq: Record "Vacation Request";
        Mgt: Codeunit VacationRequestMgt;
    begin
        CreateSubmittedRequest(VacReq);
        Mgt.ApproveRequest(VacReq);
        AssertEqual(VacationRequestStatus::Approved.AsInteger(), VacReq.Status.AsInteger(), 'Status should be Approved');
        if VacReq."Approved By" = '' then
            Error('Approved By should be set');
        if VacReq."Approved At" = 0DT then
            Error('Approved At should be set');
        CleanupRequest(VacReq);
    end;

    [Test]
    procedure ApproveRequest_WrongStatus_Errors()
    var
        VacReq: Record "Vacation Request";
        Mgt: Codeunit VacationRequestMgt;
    begin
        CreateMinimalRequest(VacReq);  // Status = Draft
        asserterror Mgt.ApproveRequest(VacReq);
        CleanupRequest(VacReq);
    end;

    // ── RejectRequest ────────────────────────────────────────────────────────

    [Test]
    procedure RejectRequest_SetsRejectedByAndAt()
    var
        VacReq: Record "Vacation Request";
        Mgt: Codeunit VacationRequestMgt;
    begin
        CreateSubmittedRequest(VacReq);
        Mgt.RejectRequest(VacReq);
        AssertEqual(VacationRequestStatus::Rejected.AsInteger(), VacReq.Status.AsInteger(), 'Status should be Rejected');
        if VacReq."Rejected By" = '' then
            Error('Rejected By should be set');
        if VacReq."Rejected At" = 0DT then
            Error('Rejected At should be set');
        CleanupRequest(VacReq);
    end;

    [Test]
    procedure RejectRequest_WrongStatus_Errors()
    var
        VacReq: Record "Vacation Request";
        Mgt: Codeunit VacationRequestMgt;
    begin
        CreateMinimalRequest(VacReq);  // Draft
        asserterror Mgt.RejectRequest(VacReq);
        CleanupRequest(VacReq);
    end;

    // ── CancelRequest ────────────────────────────────────────────────────────

    [Test]
    procedure CancelRequest_Draft_Succeeds()
    var
        VacReq: Record "Vacation Request";
        Mgt: Codeunit VacationRequestMgt;
    begin
        CreateMinimalRequest(VacReq);
        Mgt.CancelRequest(VacReq);
        AssertEqual(VacationRequestStatus::Cancelled.AsInteger(), VacReq.Status.AsInteger(), 'Status should be Cancelled');
        CleanupRequest(VacReq);
    end;

    [Test]
    procedure CancelRequest_Approved_Errors()
    var
        VacReq: Record "Vacation Request";
        Mgt: Codeunit VacationRequestMgt;
    begin
        CreateSubmittedRequest(VacReq);
        Mgt.ApproveRequest(VacReq);
        asserterror Mgt.CancelRequest(VacReq);
        CleanupRequest(VacReq);
    end;

    // ── Helpers ──────────────────────────────────────────────────────────────

    local procedure CreateMinimalRequest(var VacReq: Record "Vacation Request")
    var
        Emp: Record Employee;
        VacType: Record "Vacation Type";
    begin
        InsertTestEmployee(Emp, 'TST-EMP', 28);
        InsertTestVacationType(VacType, 'TST-ANN', false);
        VacReq.Init();
        VacReq."Employee No." := Emp."No.";
        VacReq."Vacation Type" := VacType.Code;
        VacReq."From Date" := DMY2Date(1, 8, 2026);
        VacReq.Validate("To Date", DMY2Date(5, 8, 2026));
        VacReq.Insert(false);
    end;

    local procedure CreateSubmittedRequest(var VacReq: Record "Vacation Request")
    var
        Mgt: Codeunit VacationRequestMgt;
    begin
        CreateMinimalRequest(VacReq);
        Mgt.SubmitRequest(VacReq);
    end;

    local procedure CleanupRequest(var VacReq: Record "Vacation Request")
    var
        Emp: Record Employee;
        VacType: Record "Vacation Type";
        Notif: Record "Vacation Notification";
    begin
        Notif.SetRange("Request No.", VacReq."Entry No.");
        Notif.DeleteAll(false);
        if VacReq.Delete(false) then;
        if Emp.Get('TST-EMP') then Emp.Delete(false);
        if Emp.Get('TST-BAL') then Emp.Delete(false);
        if VacType.Get('TST-ANN') then VacType.Delete(false);
        if VacType.Get('TST-BAL') then VacType.Delete(false);
    end;

    local procedure InsertTestEmployee(var Emp: Record Employee; EmpNo: Code[20]; AnnualDays: Integer)
    begin
        if Emp.Get(EmpNo) then
            exit;
        Emp.Init();
        Emp."No." := EmpNo;
        Emp."First Name" := 'Test';
        Emp."Last Name" := EmpNo;
        Emp."Employment Date" := DMY2Date(1, 1, 2020);
        Emp."Annual Vacation Days" := AnnualDays;
        Emp.Insert(false);
    end;

    local procedure InsertTestVacationType(var VacType: Record "Vacation Type"; TypeCode: Code[20]; CountInBalance: Boolean)
    begin
        if VacType.Get(TypeCode) then
            exit;
        VacType.Init();
        VacType.Code := TypeCode;
        VacType.Description := 'Test Type';
        VacType."Is Paid" := true;
        VacType."Salary Pct" := 100;
        VacType."Count In Balance" := CountInBalance;
        VacType.Insert(false);
    end;

    local procedure AssertEqual(Expected: Integer; Actual: Integer; Message: Text)
    begin
        if Expected <> Actual then
            Error('FAIL – %1. Expected: %2, Actual: %3', Message, Expected, Actual);
    end;
}
