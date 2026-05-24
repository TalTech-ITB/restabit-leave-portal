namespace RestABit.VacationManagement;

using Microsoft.HumanResources.Employee;

codeunit 50103 "RestABit Demo Data"
{
    procedure CreateDemoEmployees()
    begin
        InsertEmployee('DEMO01', 'Anna', 'Tamm', 'HR Manager', DMY2Date(15, 3, 2020), 'HR', 28);
        InsertEmployee('DEMO02', 'Jaan', 'Kask', 'Software Developer', DMY2Date(1, 7, 2022), 'IT', 28);
        InsertEmployee('DEMO03', 'Mari', 'Lepp', 'Financial Analyst', DMY2Date(10, 1, 2021), 'FINANCE', 28);
        InsertEmployee('DEMO04', 'Peeter', 'Mägi', 'IT Support Specialist', DMY2Date(22, 5, 2023), 'IT', 28);
        InsertEmployee('DEMO05', 'Liisa', 'Org', 'HR Specialist', DMY2Date(5, 11, 2019), 'HR', 30);
        InsertEmployee('DEMO06', 'Andres', 'Kivi', 'Senior Developer', DMY2Date(1, 4, 2018), 'IT', 35);
        InsertEmployee('DEMO07', 'Kadri', 'Pärn', 'Accountant', DMY2Date(12, 8, 2020), 'FINANCE', 28);
        InsertEmployee('DEMO08', 'Tõnis', 'Sepp', 'Office Manager', DMY2Date(3, 6, 2017), 'ADMINISTRATION', 35);
        InsertEmployee('DEMO09', 'Kristi', 'Vaht', 'Marketing Manager', DMY2Date(14, 2, 2021), 'MARKETING', 28);
        InsertEmployee('DEMO10', 'Mart', 'Oja', 'DevOps Engineer', DMY2Date(7, 9, 2022), 'IT', 28);
        InsertEmployee('DEMO11', 'Eva', 'Saar', 'Customer Support Lead', DMY2Date(1, 3, 2020), 'SUPPORT', 28);
        InsertEmployee('DEMO12', 'Rein', 'Tamm', 'Sales Manager', DMY2Date(15, 6, 2019), 'SALES', 30);
        InsertEmployee('DEMO13', 'Sirje', 'Kask', 'Legal Advisor', DMY2Date(20, 1, 2023), 'LEGAL', 28);
        InsertEmployee('DEMO14', 'Oliver', 'Mets', 'Junior Developer', DMY2Date(3, 2, 2025), 'IT', 28);
        InsertEmployee('DEMO15', 'Tiina', 'Rand', 'CEO', DMY2Date(1, 1, 2015), 'MANAGEMENT', 35);
    end;

    procedure CreateDemoRequests()
    begin
        // Already approved — earlier in 2026
        InsertRequest('DEMO01', 'ANNUAL', DMY2Date(12, 1, 2026), DMY2Date(23, 1, 2026), VacationRequestStatus::Approved, '');
        InsertRequest('DEMO03', 'ANNUAL', DMY2Date(2, 2, 2026), DMY2Date(13, 2, 2026), VacationRequestStatus::Approved, '');
        InsertRequest('DEMO08', 'ANNUAL', DMY2Date(16, 3, 2026), DMY2Date(27, 3, 2026), VacationRequestStatus::Approved, '');

        // Submitted — upcoming summer requests
        InsertRequest('DEMO02', 'ANNUAL', DMY2Date(15, 6, 2026), DMY2Date(3, 7, 2026), VacationRequestStatus::Submitted, '');
        InsertRequest('DEMO06', 'ANNUAL', DMY2Date(22, 6, 2026), DMY2Date(10, 7, 2026), VacationRequestStatus::Submitted, '');
        InsertRequest('DEMO07', 'ANNUAL', DMY2Date(29, 6, 2026), DMY2Date(17, 7, 2026), VacationRequestStatus::Submitted, '');

        // Draft — planned but not yet submitted
        InsertRequest('DEMO04', 'ANNUAL', DMY2Date(1, 7, 2026), DMY2Date(22, 7, 2026), VacationRequestStatus::Draft, '');
        InsertRequest('DEMO05', 'STUDY', DMY2Date(10, 6, 2026), DMY2Date(12, 6, 2026), VacationRequestStatus::Draft, 'Exam week');

        // Rejected example
        InsertRequest('DEMO01', 'ANNUAL', DMY2Date(23, 6, 2026), DMY2Date(30, 6, 2026), VacationRequestStatus::Rejected, 'Overlaps with team vacation peak period');

        // Currently on vacation TODAY (2026-05-24) — makes TeamAbsentCount > 0
        InsertRequest('DEMO09', 'ANNUAL', DMY2Date(20, 5, 2026), DMY2Date(29, 5, 2026), VacationRequestStatus::Approved, '');
        InsertRequest('DEMO10', 'ANNUAL', DMY2Date(22, 5, 2026), DMY2Date(28, 5, 2026), VacationRequestStatus::Approved, '');
        InsertRequest('DEMO12', 'ANNUAL', DMY2Date(19, 5, 2026), DMY2Date(30, 5, 2026), VacationRequestStatus::Approved, '');

        // Past sick leave
        InsertRequest('DEMO04', 'SICK-1-3', DMY2Date(5, 5, 2026), DMY2Date(7, 5, 2026), VacationRequestStatus::Approved, '');
        InsertRequest('DEMO11', 'SICK', DMY2Date(18, 5, 2026), DMY2Date(22, 5, 2026), VacationRequestStatus::Approved, '');
        InsertRequest('DEMO14', 'SICK-1-3', DMY2Date(12, 3, 2026), DMY2Date(13, 3, 2026), VacationRequestStatus::Approved, '');

        // More past approved annual
        InsertRequest('DEMO11', 'ANNUAL', DMY2Date(7, 4, 2026), DMY2Date(17, 4, 2026), VacationRequestStatus::Approved, '');
        InsertRequest('DEMO15', 'ANNUAL', DMY2Date(23, 2, 2026), DMY2Date(6, 3, 2026), VacationRequestStatus::Approved, '');
        InsertRequest('DEMO13', 'ANNUAL', DMY2Date(9, 3, 2026), DMY2Date(20, 3, 2026), VacationRequestStatus::Approved, '');

        // More submitted — pending approval
        InsertRequest('DEMO13', 'ANNUAL', DMY2Date(7, 7, 2026), DMY2Date(24, 7, 2026), VacationRequestStatus::Submitted, '');
        InsertRequest('DEMO14', 'STUDY', DMY2Date(1, 6, 2026), DMY2Date(5, 6, 2026), VacationRequestStatus::Submitted, 'State exam');
        InsertRequest('DEMO15', 'ANNUAL', DMY2Date(10, 8, 2026), DMY2Date(28, 8, 2026), VacationRequestStatus::Submitted, '');
        InsertRequest('DEMO11', 'ANNUAL', DMY2Date(3, 8, 2026), DMY2Date(14, 8, 2026), VacationRequestStatus::Submitted, '');

        // More drafts
        InsertRequest('DEMO09', 'MATERNITY', DMY2Date(1, 9, 2026), DMY2Date(30, 11, 2026), VacationRequestStatus::Draft, '');
        InsertRequest('DEMO12', 'ANNUAL', DMY2Date(17, 8, 2026), DMY2Date(28, 8, 2026), VacationRequestStatus::Draft, '');
        InsertRequest('DEMO10', 'STUDY', DMY2Date(14, 9, 2026), DMY2Date(18, 9, 2026), VacationRequestStatus::Draft, 'AL certification exam');

        // Cancelled example
        InsertRequest('DEMO02', 'ANNUAL', DMY2Date(2, 3, 2026), DMY2Date(13, 3, 2026), VacationRequestStatus::Cancelled, '');
        InsertRequest('DEMO07', 'ANNUAL', DMY2Date(4, 5, 2026), DMY2Date(8, 5, 2026), VacationRequestStatus::Cancelled, '');

        // Paternity leave
        InsertRequest('DEMO10', 'PATERNITY', DMY2Date(15, 1, 2026), DMY2Date(30, 1, 2026), VacationRequestStatus::Approved, '');
    end;

    local procedure InsertEmployee(EmpNo: Code[20]; FirstName: Text[30]; LastName: Text[30]; JobTitle: Text[30]; EmploymentDate: Date; DeptCode: Code[20]; AnnualDays: Integer)
    var
        Employee: Record Employee;
    begin
        if Employee.Get(EmpNo) then
            exit;
        Employee.Init();
        Employee."No." := EmpNo;
        Employee."First Name" := FirstName;
        Employee."Last Name" := LastName;
        Employee."Job Title" := JobTitle;
        Employee."Employment Date" := EmploymentDate;
        Employee."Global Dimension 1 Code" := DeptCode;
        Employee."Annual Vacation Days" := AnnualDays;
        Employee.Insert(false);
    end;

    local procedure InsertRequest(EmpNo: Code[20]; VacType: Code[20]; FromDate: Date; ToDate: Date; Status: Enum VacationRequestStatus; NotesText: Text[250])
    var
        VacReq: Record "Vacation Request";
        Employee: Record Employee;
    begin
        VacReq.Init();
        VacReq."Employee No." := EmpNo;
        if Employee.Get(EmpNo) then
            VacReq."Employee Name" := CopyStr(
                Employee."First Name" + ' ' + Employee."Last Name", 1, MaxStrLen(VacReq."Employee Name"));
        VacReq."Vacation Type" := VacType;
        VacReq."From Date" := FromDate;
        VacReq.Validate("To Date", ToDate);
        VacReq.Status := Status;
        VacReq.Notes := NotesText;
        VacReq."User ID" := CopyStr(UserId(), 1, MaxStrLen(VacReq."User ID"));
        case Status of
            VacationRequestStatus::Submitted:
                VacReq."Submitted At" := CreateDateTime(FromDate - 14, 090000T);
            VacationRequestStatus::Approved:
                begin
                    VacReq."Submitted At" := CreateDateTime(FromDate - 14, 090000T);
                    VacReq."Approved By" := CopyStr(UserId(), 1, MaxStrLen(VacReq."Approved By"));
                    VacReq."Approved At" := CreateDateTime(FromDate - 10, 110000T);
                end;
            VacationRequestStatus::Rejected:
                begin
                    VacReq."Submitted At" := CreateDateTime(FromDate - 14, 090000T);
                    VacReq."Rejected By" := CopyStr(UserId(), 1, MaxStrLen(VacReq."Rejected By"));
                    VacReq."Rejected At" := CreateDateTime(FromDate - 12, 140000T);
                    VacReq."Rejection Reason" := NotesText;
                    VacReq.Notes := '';
                end;
            VacationRequestStatus::Cancelled:
                VacReq."Submitted At" := CreateDateTime(FromDate - 14, 090000T);
        end;
        VacReq.Insert(false);
    end;
}
