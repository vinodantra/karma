// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'EscalationTheme.dart';
import 'EscalationWidgets.dart';

/// Confirmation screen shown after a successful escalation save.
class EscalationSuccess extends StatelessWidget {
  final String type;
  final String customer;
  final String? escalationId;

  const EscalationSuccess({
    super.key,
    required this.type,
    required this.customer,
    this.escalationId,
  });

  String _now() {
    final n = DateTime.now();
    final h24 = n.hour;
    final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
    final period = h24 < 12 ? 'AM' : 'PM';
    return '${h12.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    final id = escalationId ??
        'ESC-26-${DateTime.now().millisecondsSinceEpoch % 100000}';
    final rows = <List<String>>[
      ['Type', type],
      ['Customer', customer],
      ['Category', type == 'Ticket' ? 'Service Delay' : 'Process'],
      [
        'Improvement Area',
        type == 'Ticket' ? 'Onboarding & Setup' : 'Sales Operations'
      ],
      ['Raised by', 'You · ${_now()}'],
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const EscHeader(title: 'Escalation Saved'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 30, 22, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 84,
                    height: 84,
                    decoration: const BoxDecoration(
                      gradient: EscColors.gradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x808B47C6),
                          blurRadius: 30,
                          offset: Offset(0, 16),
                          spreadRadius: -8,
                        ),
                      ],
                    ),
                    child:
                        const Icon(Icons.check, size: 38, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Escalation raised',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: EscColors.text,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "Your escalation has been logged and assigned for review.\nYou'll be notified of any updates.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: EscColors.textSoft,
                        height: 1.55,
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: EscColors.line),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            gradient: EscColors.gradientSoft,
                            border: Border(
                              bottom: BorderSide(color: EscColors.line),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ESC. ID',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: EscColors.textSoft,
                                ),
                              ),
                              Text(
                                id,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: EscColors.text,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                        for (var i = 0; i < rows.length; i++)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 11),
                            decoration: BoxDecoration(
                              border: i == rows.length - 1
                                  ? null
                                  : const Border(
                                      bottom:
                                          BorderSide(color: EscColors.line)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  rows[i][0],
                                  style: const TextStyle(
                                      fontSize: 12, color: EscColors.textSoft),
                                ),
                                Flexible(
                                  child: Text(
                                    rows[i][1],
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: EscColors.text,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  EscGradientButton(
                    label: 'View Escalation',
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(height: 10),
                  EscOutlineButton(
                    label: 'Back to Operations',
                    onPressed: () {
                      // Pop all escalation screens back to whatever opened the flow.
                      Get.until((route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
