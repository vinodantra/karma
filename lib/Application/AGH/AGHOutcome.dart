// ignore_for_file: file_names, unused_element, unused_import
import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/aghController.dart';

import 'AGHTheme.dart';
import 'AGHWidgets.dart';
import 'AGHMemberLearn.dart';

class AGHOutcome extends StatefulWidget {
  const AGHOutcome({super.key});

  @override
  State<AGHOutcome> createState() => _AGHOutcomeState();
}

class _AGHOutcomeState extends State<AGHOutcome> {
  late final AGHController controller;
  late final TextEditingController _remarkCtrl;

  bool get _isCaptain => controller.isCurrentUserCaptain;

  /// The logged-in user's own remark from the loaded session.
  bool get _ownRemarkEmpty {
    final s = controller.activeSession.value;
    final own = (_isCaptain ? s?.captainRemark : s?.memberRemark) ?? '';
    return own.trim().isEmpty;
  }

  @override
  void initState() {
    super.initState();
    controller = Get.find<AGHController>();
    _remarkCtrl = TextEditingController(
      text: _isCaptain
          ? controller.captainOutput.value
          : controller.memberOutput.value,
    );
  }

  @override
  void dispose() {
    _remarkCtrl.dispose();
    super.dispose();
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

  Future<void> _enhanceOutput() async {
    final enhanced = await controller.enhanceOutput();
    if (enhanced != null) _remarkCtrl.text = enhanced;
  }

  void _previousOutput() {
    _remarkCtrl.text = controller.restorePreviousOutput();
  }

  /// Submits the logged-in user's remark using the same SAVEAGH call as the
  /// check-out flow in AGHCheckIn.
  Future<void> _submitRemark() async {
    if (controller.isCheckingIn.value) return;
    final text = _remarkCtrl.text.trim();
    if (text.isEmpty) {
      _toast('Please enter your remark.');
      return;
    }
    if (_isCaptain) {
      controller.setCaptainOutput(text);
    } else {
      controller.setMemberOutput(text);
    }
    // Ensure a check-in/out timestamp exists, then post via the shared API.
    if (!controller.currentUserCheckedIn) controller.checkInLocally();
    controller.endSession();
    final error = await controller.postCheckOut();
    if (!mounted) return;
    if (error != null) {
      _toast(error);
      return;
    }
    controller.setTab('Completed');
    controller.fetchUpcoming();
    Get.back();
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
            const AGHHeader(title: 'Session Outcome'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => _SessionDetailsCard(
                          session: controller.activeSession.value,
                        )),
                    const SizedBox(height: 14),
                    Obx(() => _MemberCard(
                          submitted: controller.memberLearningSubmitted.value,
                          memberName:
                              controller.activeSession.value?.name ?? 'Member',
                          learningText: controller.memberOutput.value,
                          remarkAt:
                              controller.activeSession.value?.memberRemarkAt ??
                                  '',
                        )),
                    const SizedBox(height: 14),
                    Obx(() => _CaptainFeedbackCard(
                          unlocked: controller.memberLearningSubmitted.value ||
                              controller.captainOutput.value.trim().isNotEmpty,
                          feedbackText: controller.captainOutput.value,
                          remarkAt:
                              controller.activeSession.value?.captainRemarkAt ??
                                  '',
                        )),
                    const SizedBox(height: 12),
                    if (_ownRemarkEmpty) ...[
                      _SubmitRemarkBox(
                        controller: _remarkCtrl,
                        isCaptain: _isCaptain,
                        onChanged: _isCaptain
                            ? controller.setCaptainOutput
                            : controller.setMemberOutput,
                      ),
                      Obx(() {
                        final output = (_isCaptain
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
                      const SizedBox(height: 14),
                      Obx(() => AGHGradientButton(
                            label: controller.isCheckingIn.value
                                ? 'Saving…'
                                : 'Submit Remark',
                            onPressed: controller.isCheckingIn.value
                                ? null
                                : _submitRemark,
                          )),
                      const SizedBox(height: 12),
                    ],
                    // Obx(() {
                    //   if (controller.memberLearningSubmitted.value) {
                    //     return const SizedBox.shrink();
                    //   }
                    //   return Center(
                    //     child: TextButton.icon(
                    //       icon: const Icon(Icons.swap_horiz,
                    //           size: 14, color: AGHColors.purple),
                    //       label: const Text(
                    //         'Open Member view · Submit Learning',
                    //         style: TextStyle(
                    //           fontSize: 11.5,
                    //           color: AGHColors.purple,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       onPressed: () => Get.to(() => const AGHMemberLearn()),
                    //     ),
                    //   );
                    // }),
                    // const SizedBox(height: 12),
                    // Obx(() {
                    //   final unlocked = controller.memberLearningSubmitted.value;
                    //   return Opacity(
                    //     opacity: unlocked ? 1 : 0.5,
                    //     child: AGHGradientButton(
                    //       label: 'Final Save · Lock Session',
                    //       onPressed: unlocked
                    //           ? () {
                    //               controller.finalSaveSession();
                    //               // Pop Outcome + CheckIn → back to Dashboard
                    //               Get.back();
                    //               Get.back();
                    //             }
                    //           : null,
                    //     ),
                    //   );
                    // }),
                    // const SizedBox(height: 10),
                    // const Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       'Locking records this as an official AGH session.\nNo further edits allowed after save.',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(
                    //         fontSize: 10.5,
                    //         color: AGHColors.textFaint,
                    //         height: 1.5,
                    //       ),
                    //     ),
                    //   ],
                    // ),
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

/// Editable remark box shown on the Outcome screen when the logged-in user
/// hasn't submitted their own remark yet.
class _SubmitRemarkBox extends StatelessWidget {
  final TextEditingController controller;
  final bool isCaptain;
  final ValueChanged<String> onChanged;

  const _SubmitRemarkBox({
    required this.controller,
    required this.isCaptain,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isCaptain ? 'YOUR FEEDBACK' : 'YOUR LEARNING',
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
            controller: controller,
            onChanged: onChanged,
            minLines: 3,
            maxLines: 5,
            style: const TextStyle(fontSize: 13.5, color: AGHColors.text),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: isCaptain
                  ? 'Capture what you observed and decisions taken…'
                  : 'Capture what you shared and committed to…',
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

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AGHController>();
    return Obx(() {
      final start = controller.sessionStartedAt.value;
      final end = controller.checkOutAt.value;
      final duration = (start != null && end != null)
          ? '${end.difference(start).inMinutes.clamp(1, 999)}m'
          : '—';
      final checkIn = controller.captainCheckInAt.value ??
          controller.memberCheckInAt.value ??
          '—';
      final mode = controller.activeSession.value?.mode ?? '—';
      final topics = controller.selectedTopics.length.toString();
      final stats = [
        ['Duration', duration],
        ['Check-in', checkIn],
        ['Mode', mode],
        ['Topics', topics],
      ];
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: AGHColors.gradientSoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: stats.map((s) {
            return Expanded(
              child: Column(
                children: [
                  Text(
                    s[1],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AGHColors.text,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                      color: AGHColors.textSoft,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}

class _SessionDetailsCard extends StatelessWidget {
  final AGHScheduledSession? session;
  const _SessionDetailsCard({required this.session});

  /// Total meeting time. Captain uses captain_start/end, member uses
  /// user_start/end.
  String _totalTime() {
    final isCaptain = DataInfo.tcId.value == '7';
    final startRaw = isCaptain ? session?.captainStart : session?.userStart;
    final endRaw = isCaptain ? session?.captainEnd : session?.userEnd;
    final start = DateTime.tryParse(startRaw ?? '');
    final end = DateTime.tryParse(endRaw ?? '');
    if (start == null || end == null) return '—';
    final mins = end.difference(start).inMinutes;
    if (mins <= 0) return '0m';
    final h = mins ~/ 60;
    final m = mins % 60;
    if (h > 0) return m > 0 ? '${h}h ${m}m' : '${h}h';
    return '${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final s = session;
    final topic = (s?.topicName ?? '').trim();
    final notes = (s?.notes ?? '').trim();
    final mode = (s?.mode ?? '').trim();
    final topicLabel =
        topic.isEmpty ? '—' : AGHTopic(id: 0, name: topic).display;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AGHColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Session Details',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AGHColors.text,
            ),
          ),
          const SizedBox(height: 10),
          _DetailRow(label: 'Topic', value: topicLabel),
          const SizedBox(height: 6),
          _DetailRow(label: 'Meeting Mode', value: mode.isEmpty ? '—' : mode),
          const SizedBox(height: 6),
          _DetailRow(label: 'Total Time', value: _totalTime()),
          const SizedBox(height: 6),
          _DetailRow(label: 'Notes', value: notes.isEmpty ? '—' : notes),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: AGHColors.textFaint,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              color: AGHColors.text,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

String _formatRemarkAt(String raw) {
  if (raw.trim().isEmpty) return '';
  final dt = DateTime.tryParse(raw);
  if (dt == null) return raw;
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  final h24 = dt.hour;
  final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
  final period = h24 < 12 ? 'AM' : 'PM';
  return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year} · '
      '${h12.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $period';
}

class _MemberCard extends StatelessWidget {
  final bool submitted;
  final String memberName;
  final String learningText;
  final String remarkAt;

  const _MemberCard({
    required this.submitted,
    required this.memberName,
    this.learningText = '',
    this.remarkAt = '',
  });

  @override
  Widget build(BuildContext context) {
    final hasText = learningText.trim().isNotEmpty;
    // final showText = submitted || hasText;
    final ts = _formatRemarkAt(remarkAt);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AGHColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AGHAvatar(name: memberName, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What I Learned',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AGHColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              // AGHStatusChip(
              //   kind: showText ? AGHStatus.submitted : AGHStatus.due,
              //   label: showText ? 'Submitted' : 'Pending',
              // ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            hasText
                ? learningText
                : 'Member has not submitted their learning yet.',
            style: TextStyle(
              fontSize: 12.5,
              color: hasText ? AGHColors.text : AGHColors.textFaint,
              height: 1.55,
              fontStyle: hasText ? FontStyle.normal : FontStyle.italic,
            ),
          ),
          if (ts.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Submitted · $ts',
              style: const TextStyle(
                fontSize: 10.5,
                color: AGHColors.textFaint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CaptainFeedbackCard extends StatelessWidget {
  final bool unlocked;
  final String feedbackText;
  final String remarkAt;
  const _CaptainFeedbackCard({
    required this.unlocked,
    this.feedbackText = '',
    this.remarkAt = '',
  });

  @override
  Widget build(BuildContext context) {
    if (!unlocked) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AGHColors.pageBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AGHColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Captain Feedback',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AGHColors.text,
                  ),
                ),
                Icon(Icons.lock_outline, size: 16, color: AGHColors.textSoft),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AGHColors.line),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.hourglass_top,
                      size: 14, color: AGHColors.textSoft),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Waiting for Member to submit Learning Outcome.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AGHColors.textSoft,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AGHColors.pink.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AGHColors.pink, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Captain Feedback',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AGHColors.text,
                ),
              ),
              // AGHStatusChip(kind: AGHStatus.upcoming, label: 'SUBMITTED'),
            ],
          ),
          const SizedBox(height: 10),
          feedbackText.trim().isEmpty
              ? const Text(
                  'No captain feedback yet.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AGHColors.textFaint,
                    height: 1.55,
                    fontStyle: FontStyle.italic,
                  ),
                )
              : Text(
                  feedbackText,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AGHColors.text,
                    height: 1.55,
                  ),
                ),
          if (_formatRemarkAt(remarkAt).isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Submitted · ${_formatRemarkAt(remarkAt)}',
              style: const TextStyle(
                fontSize: 10.5,
                color: AGHColors.textFaint,
              ),
            ),
          ],
          // const SizedBox(height: 10),
          // Container(
          //   padding: const EdgeInsets.only(top: 10),
          //   decoration: const BoxDecoration(
          //     border: Border(top: BorderSide(color: AGHColors.line)),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text(
          //         'Member cannot see or edit',
          //         style: TextStyle(
          //           fontSize: 10.5,
          //           color: AGHColors.textFaint,
          //         ),
          //       ),
          //       Text(
          //         '${feedbackText.length} / 500',
          //         style: const TextStyle(
          //           fontSize: 10.5,
          //           color: AGHColors.textSoft,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
