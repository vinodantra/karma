// ignore_for_file: file_names

import 'dart:async';

import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/aghController.dart';

import 'AGHTheme.dart';
import 'AGHWidgets.dart';

class AGHCheckIn extends StatefulWidget {
  final bool fromPending;
  const AGHCheckIn({super.key, this.fromPending = false});

  @override
  State<AGHCheckIn> createState() => _AGHCheckInState();
}

class _AGHCheckInState extends State<AGHCheckIn> {
  late final AGHController controller;
  late final TextEditingController _captainCtrl;
  late final TextEditingController _memberCtrl;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AGHController>();

    _captainCtrl = TextEditingController(text: controller.captainOutput.value);
    _memberCtrl = TextEditingController(text: controller.memberOutput.value);
    controller.setButtonStatus();
    Utilities.getLocation();
  }

  @override
  void dispose() {
    _captainCtrl.dispose();
    _memberCtrl.dispose();
    super.dispose();
  }

  void _handleCheckIn() {
    if (controller.currentUserCheckedIn) return;
    controller.checkInLocally();
  }

  Future<void> _handleCheckOut() async {
    if (controller.isCheckingIn.value) return;
    if (!controller.currentUserCheckedIn) return;

    // Block check-out when the scheduled date is more than 2 days away from
    // today (compared on date only, e.g. 2026-06-19T11:00 → 2026-06-19).
    // final scheduledAt = controller.activeSession.value?.scheduledAt;
    // if (scheduledAt != null) {
    //   final now = DateTime.now();
    //   final today = DateTime(now.year, now.month, now.day);
    //   final scheduled =
    //       DateTime(scheduledAt.year, scheduledAt.month, scheduledAt.day);
    //   if (scheduled.difference(today).inDays.abs() > 2) {
    //     _toast('Check-out is only allowed within 2 days of the scheduled date.');
    //     return;
    //   }
    // }

    //final isCaptain = controller.isCurrentUserCaptain;
    // final output = isCaptain
    //     ? controller.captainOutput.value.trim()
    //     : controller.memberOutput.value.trim();
    // if (output.isEmpty) {
    //   _toast(isCaptain
    //       ? 'Please enter the Captain output before checking out.'
    //       : 'Please enter the Member output before checking out.');
    //   return;
    // }

    controller.endSession();
    final error = await controller.postCheckOut();
    if (!mounted) return;
    if (error != null) {
      _toast(error);
      return;
    }
    controller.setTab(widget.fromPending ? 'Completed' : 'Pending');
    controller.fetchUpcoming();
    Get.back();
  }

  Future<void> _enhanceOutput() async {
    final isCaptain = DataInfo.tcId.value == '7';
    final enhanced = await controller.enhanceOutput();
    if (enhanced != null) {
      (isCaptain ? _captainCtrl : _memberCtrl).text = enhanced;
    }
  }

  void _previousOutput() {
    final isCaptain = DataInfo.tcId.value == '7';
    (isCaptain ? _captainCtrl : _memberCtrl).text =
        controller.restorePreviousOutput();
  }

  void _toast(String message) {
    Get.snackbar(
      'AGH Session',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const AGHHeader(
              title: 'Session Room',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final s = controller.activeSession.value;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AGH · ${s?.date.toUpperCase() ?? '—'}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AGHColors.textFaint,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'With ${s?.name ?? '—'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AGHColors.text,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${s?.time ?? '—'} · ${s?.mode ?? '—'}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AGHColors.textSoft,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const _SessionTimer(),
                        ],
                      );
                    }),
                    const SizedBox(height: 18),
                    Obx(() {
                      final isCaptain = DataInfo.tcId.value == '7';
                      final checkedInAt = isCaptain
                          ? controller.captainCheckInAt.value
                          : controller.memberCheckInAt.value;
                      return _CheckInSlot(
                        role: isCaptain ? 'CAPTAIN' : 'MEMBER',
                        name: 'You',
                        // isCaptain
                        //     ? 'You'
                        //     : (controller.activeSession.value?.name ?? '—'),
                        checkedInAt: checkedInAt,
                        onCheckIn: _handleCheckIn,
                      );
                    }),
                    const SizedBox(height: 14),
                    Obx(() {
                      if (controller.currentUserCheckedIn) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 102, 78, 30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: AGHColors.warn,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Tap Check In to record your attendance and start the session.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: AGHColors.warn,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 22),
                    const Text(
                      'DISCUSSION TOPIC',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AGHColors.textSoft,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      final raw =
                          controller.activeSession.value?.topicName ?? '';
                      final parts = raw
                          .split(',')
                          .map((s) => s.trim())
                          .where((s) => s.isNotEmpty)
                          .toList();
                      if (parts.isEmpty) {
                        return const Text(
                          'No topic selected for this session.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AGHColors.textFaint,
                          ),
                        );
                      }
                      final remark = controller.otherTopicRemark.value.trim();
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final name in parts)
                            AGHTopicChip(
                              label: name.toLowerCase() == 'other'
                                  ? (remark.isNotEmpty
                                      ? 'Other · $remark'
                                      : 'Other')
                                  : AGHTopic(id: 0, name: name).display,
                              selected: true,
                            ),
                        ],
                      );
                    }),
                    const SizedBox(height: 22),
                    Obx(() {
                      final isCaptain = DataInfo.tcId.value == '7';
                      return _OutputField(
                        label: 'OUTPUT',
                        hint: isCaptain
                            ? 'Capture what you observed and decisions taken…'
                            : 'Capture what you shared and committed to…',
                        textController: isCaptain ? _captainCtrl : _memberCtrl,
                        onChanged: isCaptain
                            ? controller.setCaptainOutput
                            : controller.setMemberOutput,
                      );
                    }),
                    Obx(() {
                      final isCaptain = DataInfo.tcId.value == '7';
                      final output = (isCaptain
                              ? controller.captainOutput.value
                              : controller.memberOutput.value)
                          .trim();
                      if (output.length < 15) return const SizedBox.shrink();
                      final hasPrevious =
                          controller.outputPrevious.value.isNotEmpty;
                      final busy = controller.isEnhancingOutput.value;
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: hasPrevious
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.end,
                          children: [
                            if (hasPrevious)
                              _OutputActionButton(
                                label: 'Previous Remark',
                                outlined: true,
                                onTap: busy ? null : _previousOutput,
                              ),
                            _OutputActionButton(
                              label: busy ? 'Enhancing…' : 'Enhance Text',
                              outlined: false,
                              onTap: busy ? null : _enhanceOutput,
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 22),
                    Obx(() {
                      final s = controller.activeSession.value;
                      final isCaptain = DataInfo.tcId.value == '7';
                      final start =
                          ((isCaptain ? s?.captainStart : s?.userStart) ?? '')
                              .trim();
                      final end =
                          ((isCaptain ? s?.captainEnd : s?.userEnd) ?? '')
                              .trim();
                      // User has both checked in and out → hide the button.
                      final alreadyCheckedOut =
                          start.isNotEmpty && end.isNotEmpty;
                      if (alreadyCheckedOut) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AGHColors.successSoft,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AGHColors.success),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline,
                                  size: 16, color: AGHColors.success),
                              SizedBox(width: 8),
                              Text(
                                'You have already checked out.',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AGHColors.success,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final canEnd = controller.currentUserCheckedIn &&
                          !controller.isCheckingIn.value;
                      return Opacity(
                        opacity: canEnd ? 1 : 0.5,
                        child: AGHOutlineButton(
                          label: controller.isCheckingIn.value
                              ? 'Saving…'
                              : 'End Session · Check-Out',
                          onPressed: canEnd ? _handleCheckOut : null,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Live MM:SS / HH:MM:SS counter that starts when both participants
/// have checked in.
class _SessionTimer extends StatefulWidget {
  const _SessionTimer();

  @override
  State<_SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<_SessionTimer> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AGHController>();
    return Obx(() {
      final start = controller.sessionStartedAt.value;
      final label = start == null
          ? '00:00:00'
          : _format(DateTime.now().difference(start));
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: AGHColors.gradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
    });
  }
}

class _CheckInSlot extends StatelessWidget {
  final String role;
  final String name;
  final String? checkedInAt;
  final VoidCallback onCheckIn;

  const _CheckInSlot({
    required this.role,
    required this.name,
    required this.checkedInAt,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final checkedIn = checkedInAt != null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: checkedIn ? AGHColors.successSoft : AGHColors.pageBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: checkedIn ? AGHColors.success : AGHColors.line,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   role,
          //   style: TextStyle(
          //     fontSize: 10.5,
          //     fontWeight: FontWeight.w600,
          //     letterSpacing: 0.4,
          //     color: checkedIn ? AGHColors.success : AGHColors.textSoft,
          //   ),
          // ),
          // const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AGHColors.text,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          if (checkedIn)
            Row(
              children: [
                const Icon(Icons.check, size: 14, color: AGHColors.success),
                const SizedBox(width: 6),
                Text(
                  'Checked in · $checkedInAt',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AGHColors.success,
                  ),
                ),
              ],
            )
          else
            GestureDetector(
              onTap: onCheckIn,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  gradient: AGHColors.gradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Check In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OutputActionButton extends StatelessWidget {
  final String label;
  final bool outlined;
  final VoidCallback? onTap;

  const _OutputActionButton({
    required this.label,
    required this.outlined,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.5 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            gradient: outlined ? null : AGHColors.gradient,
            color: outlined ? Colors.white : null,
            borderRadius: BorderRadius.circular(20),
            border: outlined ? Border.all(color: AGHColors.purple) : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: outlined ? AGHColors.purple : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _OutputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController textController;
  final ValueChanged<String> onChanged;

  const _OutputField({
    required this.label,
    required this.hint,
    required this.textController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AGHColors.textSoft,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AGHColors.pageBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AGHColors.line),
          ),
          child: TextField(
            controller: textController,
            onChanged: onChanged,
            minLines: 3,
            maxLines: 5,
            style: const TextStyle(fontSize: 13.5, color: AGHColors.text),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 13,
                color: AGHColors.textFaint,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
