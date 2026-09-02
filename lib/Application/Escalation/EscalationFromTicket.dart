// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

import 'EscalationTicketForm.dart';

/// Escalation entry used when raising a ticket escalation from a ticket-details
/// screen (DataPoint → Tickets → Ticket Details).
///
/// The customer comes from the DataPoint context ([DataInfo.dpId] /
/// [DataInfo.dpName]) and the ticket number is passed in. It reuses
/// [EscalationTicketForm] in preset mode, so Customer Name and Ticket No are
/// locked and the 2-month rule (derived from the ticket number) applies.
class EscalationFromTicket extends StatelessWidget {
  final String ticketNo;

  const EscalationFromTicket({super.key, required this.ticketNo});

  @override
  Widget build(BuildContext context) {
    return EscalationTicketForm(
      presetDpId: DataInfo.dpId.value,
      presetCustomerName: DataInfo.dpName.value,
      presetTicketNo: ticketNo,
    );
  }
}
