// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'EscalationTheme.dart';
import 'EscalationWidgets.dart';
import 'EscalationTicketForm.dart';
import 'EscalationInternalForm.dart';

/// Step 1 of the Raise Escalation flow — pick Ticket or Internal.
class EscalationChooseType extends StatelessWidget {
  const EscalationChooseType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EscColors.pageBg,
      body: Column(
        children: [
          const EscHeader(
            title: 'Raise Escalation',
            subtitle:
                'Choose what you want to escalate. You can flag a customer ticket or raise an internal issue.',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
              child: Column(
                children: [
                  _TypeCard(
                    tag: 'CUSTOMER',
                    title: 'Ticket',
                    desc:
                        'Flag an existing customer ticket that needs higher-level attention.',
                    mandatoryCount: 8,
                    filled: true,
                    icon: Icons.confirmation_number_outlined,
                    onTap: () => Get.to(() => const EscalationTicketForm()),
                  ),
                  const SizedBox(height: 14),
                  _TypeCard(
                    tag: 'INTERNAL',
                    title: 'Internal',
                    desc:
                        'Raise an internal issue — process, tools, team, or workflow concerns.',
                    mandatoryCount: 6,
                    filled: false,
                    icon: Icons.groups_2_outlined,
                    onTap: () => Get.to(() => const EscalationInternalForm()),
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

class _TypeCard extends StatelessWidget {
  final String tag;
  final String title;
  final String desc;
  final int mandatoryCount;
  final bool filled;
  final IconData icon;
  final VoidCallback onTap;

  const _TypeCard({
    required this.tag,
    required this.title,
    required this.desc,
    required this.mandatoryCount,
    required this.filled,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconBoxBg = filled
        ? Colors.white.withValues(alpha: 0.20)
        : EscColors.purple.withValues(alpha: 0.08);
    final iconColor = filled ? Colors.white : EscColors.purple;
    final textColor = filled ? Colors.white : EscColors.text;
    final softColor =
        filled ? Colors.white.withValues(alpha: 0.92) : EscColors.textSoft;
    final tagColor =
        filled ? Colors.white.withValues(alpha: 0.85) : EscColors.textFaint;
    final dividerColor =
        filled ? Colors.white.withValues(alpha: 0.25) : EscColors.line;
    final ctaColor = filled ? Colors.white : EscColors.pink;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 14),
        decoration: BoxDecoration(
          gradient: filled ? EscColors.gradient : null,
          color: filled ? null : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: filled ? null : Border.all(color: EscColors.line, width: 1.5),
          boxShadow: filled
              ? const [
                  BoxShadow(
                    color: Color(0x4D8B47C6),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                    spreadRadius: -8,
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Color(0x0A141428),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBoxBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tag,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: tagColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        desc,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: softColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: dividerColor),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text(
                //   '$mandatoryCount mandatory fields',
                //   style: TextStyle(
                //     fontSize: 11.5,
                //     fontWeight: FontWeight.w500,
                //     color: softColor,
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: ctaColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 14, color: ctaColor),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
