namespace RestABit.VacationManagement;

enum 50101 VacationRequestStatus
{
    Extensible = false;

    value(0; Draft) { Caption = 'Draft'; }
    value(1; Submitted) { Caption = 'Submitted'; }
    value(2; Approved) { Caption = 'Approved'; }
    value(3; Rejected) { Caption = 'Rejected'; }
}
