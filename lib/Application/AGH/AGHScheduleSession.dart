// ignore_for_file: file_names, unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karma/Controller/aghController.dart';

import 'AGHTheme.dart';
import 'AGHWidgets.dart';

/// Captain schedules (or reschedules) a session with a specific member.
class AGHScheduleSession extends StatefulWidget {
  final String memberUserId;
  final String memberName;
  final String memberLast;
  final String memberTopic;
  final String memberRole;

  /// When provided, the screen edits an existing schedule and the meeting id
  /// is forwarded to AGHSCHEDULE so the API performs an update.
  final String meetingId;

  /// Latest date a session may be scheduled (the member's expire_date).
  final DateTime? expireDate;

  /// Existing values when editing a schedule (reschedule).
  final String memberNotes;
  final String memberMode;
  final DateTime? scheduledAt;

  const AGHScheduleSession({
    super.key,
    this.memberUserId = '',
    this.memberName = 'Rahul Mehta',
    this.memberLast = '08 Apr 2026',
    this.memberTopic = '',
    this.memberRole = '',
    this.meetingId = '',
    this.expireDate,
    this.memberNotes = '',
    this.memberMode = '',
    this.scheduledAt,
  });

  @override
  State<AGHScheduleSession> createState() => _AGHScheduleSessionState();
}

class _AGHScheduleSessionState extends State<AGHScheduleSession> {
  late final AGHController controller;
  late final TextEditingController _notesCtrl;
  late final TextEditingController _otherCtrl;
  Worker? _topicsListener;

  static const _months = [
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
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.find<AGHController>();
    // Fresh create: reset the whole form so a previous schedule's notes,
    // date/time, mode and topics don't carry over. Reschedule: load this
    // session's own values instead of whatever was last in the controller.
    if (widget.meetingId.isEmpty) {
      controller.resetScheduleForm();
    } else {
      controller.resetScheduleForm();
      controller.scheduleNotes.value = widget.memberNotes;
      if (widget.memberMode.isNotEmpty && widget.memberMode != '—') {
        controller.scheduleMode.value = widget.memberMode;
      }
      final at = widget.scheduledAt;
      if (at != null) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final date = DateTime(at.year, at.month, at.day);
        // A past schedule (missed) can't be re-scheduled into the past.
        controller.scheduleDate.value = date.isBefore(today) ? today : date;
        controller.scheduleTime.value =
            TimeOfDay(hour: at.hour, minute: at.minute);
      }
    }
    _notesCtrl = TextEditingController(text: controller.scheduleNotes.value);
    _otherCtrl = TextEditingController(text: controller.otherTopicRemark.value);
    _preselectTopic();
  }

  @override
  void dispose() {
    _topicsListener?.dispose();
    _notesCtrl.dispose();
    _otherCtrl.dispose();
    super.dispose();
  }

  bool _applyTopicPreselect() {
    final wanted = widget.memberTopic.trim().toLowerCase();
    if (wanted.isEmpty) return true;
    // Comma-separated topic names (or ids) coming from an existing schedule.
    final wantedParts =
        wanted.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty);
    final matches = <AGHTopic>[];
    for (final w in wantedParts) {
      final asId = int.tryParse(w);
      final m = controller.topics.firstWhereOrNull(
        (t) =>
            t.name.trim().toLowerCase() == w || (asId != null && t.id == asId),
      );
      if (m != null) matches.add(m);
    }
    if (matches.isEmpty) return false;
    controller.selectedTopicList.assignAll(matches);
    return true;
  }

  void _preselectTopic() {
    if (widget.memberTopic.isEmpty) return;
    if (_applyTopicPreselect()) return;
    _topicsListener = ever<List<AGHTopic>>(controller.topics, (list) {
      if (list.isEmpty) return;
      if (_applyTopicPreselect()) _topicsListener?.dispose();
    });
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';
  }

  String _formatTime(TimeOfDay? t) {
    if (t == null) return '';
    final h12 = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final mm = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '${h12.toString().padLeft(2, '0')}:$mm $period';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final lastDate = DateTime(now.year + 2);
    var current = controller.scheduleDate.value ?? today;
    if (current.isBefore(today)) current = today;
    if (current.isAfter(lastDate)) current = lastDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: today,
      lastDate: lastDate,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AGHColors.pink,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AGHColors.text,
          ),
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );
    if (picked != null) controller.setScheduleDate(picked);
  }

  String _formatApiDateTime(DateTime d, TimeOfDay t) {
    const monthsLower = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec',
    ];
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '${d.day.toString().padLeft(2, '0')} ${monthsLower[d.month - 1]} ${d.year} $hh:$mm';
  }

  Future<void> _submitSchedule() async {
    final date = controller.scheduleDate.value;
    final time = controller.scheduleTime.value;
    final selected = controller.selectedTopicList;

    if (date == null) {
      _toast('Please select a date.');
      return;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (DateTime(date.year, date.month, date.day).isBefore(today)) {
      _toast('Please select today or a future date.');
      return;
    }
    // final expire = widget.expireDate;
    // if (expire != null) {
    //   final picked = DateTime(date.year, date.month, date.day);
    //   final exp = DateTime(expire.year, expire.month, expire.day);
    //   if (picked.isAfter(exp)) {
    //     _toast('Cannot schedule after the expiry date '
    //         '(${_formatDate(exp)}).');
    //     return;
    //   }
    // }
    if (time == null) {
      _toast('Please select a time.');
      return;
    }
    if (selected.isEmpty) {
      _toast('Please select at least one discussion topic.');
      return;
    }
    if (widget.memberUserId.isEmpty) {
      _toast('Member id is missing.');
      return;
    }

    final hasOther = controller.isOtherTopicSelected;
    final remark = controller.otherTopicRemark.value.trim();
    if (hasOther && remark.isEmpty) {
      _toast('Please enter the "Other" topic detail.');
      return;
    }

    final topicIds = selected.map((t) => t.id).join(',');
    final error = await controller.createSchedule(
      memberUserId: widget.memberUserId,
      dateTime: _formatApiDateTime(date, time),
      mode: controller.scheduleMode.value,
      topicIds: topicIds,
      notes: controller.scheduleNotes.value,
      remark: hasOther ? remark : null,
      meetingId: widget.meetingId.isEmpty ? null : widget.meetingId,
    );

    if (error != null) {
      _toast(error);
      return;
    }

    // Back to the dashboard, show the Scheduled tab and refresh via GETAGH.
    Get.back();
    controller.setTab('Scheduled');
    await controller.fetchUpcoming(force: true);
    _toast('Session scheduled successfully.');
  }

  Future<void> _enhanceNotes() async {
    final enhanced = await controller.enhanceScheduleNotes();
    if (enhanced != null) _notesCtrl.text = enhanced;
  }

  void _previousNotes() {
    _notesCtrl.text = controller.restorePreviousNotes();
  }

  void _toast(String message) {
    Get.snackbar(
      'Schedule',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _pickTime() async {
    final now = DateTime.now();
    final date = controller.scheduleDate.value;
    final isToday = date != null &&
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    final fallback = isToday
        ? TimeOfDay(hour: now.hour, minute: now.minute)
        : const TimeOfDay(hour: 11, minute: 0);
    final initial = controller.scheduleTime.value ?? fallback;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AGHColors.pink,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AGHColors.text,
          ),
        ),
        // Force the 12-hour AM/PM picker regardless of the device's
        // 24-hour system setting.
        child: MediaQuery(
          data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: false),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
    if (picked == null) return;
    if (isToday) {
      final pickedMinutes = picked.hour * 60 + picked.minute;
      final nowMinutes = now.hour * 60 + now.minute;
      if (pickedMinutes < nowMinutes) {
        _toast('Please select a time after the current time.');
        return;
      }
    }
    controller.setScheduleTime(picked);
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
            const AGHHeader(title: 'Schedule Session'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MemberCard(
                        name: widget.memberName,
                        last: widget.memberLast,
                        role: widget.memberRole),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _pickDate,
                            child: Obx(() => AGHUnderlined(
                                  label: 'Date',
                                  value: _formatDate(
                                      controller.scheduleDate.value),
                                  placeholder: 'Select date',
                                )),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _pickTime,
                            child: Obx(() => AGHUnderlined(
                                  label: 'Time',
                                  value: _formatTime(
                                      controller.scheduleTime.value),
                                  placeholder: 'Select time',
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Mode',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AGHColors.text,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() => Row(
                          children: [
                            Expanded(
                              child: _ModeTile(
                                label: 'Office',
                                icon: Icons.apartment_outlined,
                                selected:
                                    controller.scheduleMode.value == 'Office',
                                onTap: () => controller.setMode('Office'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _ModeTile(
                                label: 'Online',
                                icon: Icons.videocam_outlined,
                                selected:
                                    controller.scheduleMode.value == 'Online',
                                onTap: () => controller.setMode('Online'),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 20),
                    const Text(
                      'Discussion Topic',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AGHColors.text,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (controller.isLoadingTopics.value &&
                          controller.topics.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AGHColors.pink,
                            ),
                          ),
                        );
                      }
                      final all = <AGHTopic>[
                        ...controller.topics,
                      ];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: all.map((t) {
                              final selected = controller.isTopicSelected(t);
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => controller.toggleTopic(t),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AGHColors.pink.withValues(alpha: 0.10)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: selected
                                          ? AGHColors.pink
                                          : AGHColors.line,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (selected)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 6),
                                          child: Icon(Icons.check,
                                              size: 14, color: AGHColors.pink),
                                        ),
                                      Text(
                                        t.id == 0 ? 'Other' : t.display,
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: selected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          color: selected
                                              ? AGHColors.pink
                                              : AGHColors.textSoft,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          if (controller.isOtherTopicSelected) ...[
                            const SizedBox(height: 12),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: AGHColors.line, width: 1),
                                ),
                              ),
                              child: TextField(
                                controller: _otherCtrl,
                                onChanged: controller.setOtherTopicRemark,
                                maxLines: 2,
                                minLines: 1,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AGHColors.text,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(bottom: 6),
                                  hintText: 'Enter other topic…',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: AGHColors.textFaint,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    }),
                    const SizedBox(height: 20),
                    const Text(
                      'Notes (Optional)',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AGHColors.textSoft,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AGHColors.line, width: 1),
                        ),
                      ),
                      child: TextField(
                        controller: _notesCtrl,
                        maxLines: 3,
                        minLines: 1,
                        onChanged: controller.setScheduleNotes,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AGHColors.text,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 6),
                          hintText: 'Add a note for this session…',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: AGHColors.textFaint,
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      final notes = controller.scheduleNotes.value.trim();
                      if (notes.length < 15) return const SizedBox.shrink();
                      final hasPrevious =
                          controller.notesPrevious.value.isNotEmpty;
                      final busy = controller.isEnhancingNotes.value;
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: hasPrevious
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.end,
                          children: [
                            if (hasPrevious)
                              _NotesActionButton(
                                label: 'Previous Remark',
                                outlined: true,
                                onTap: busy ? null : _previousNotes,
                              ),
                            _NotesActionButton(
                              label: busy ? 'Enhancing…' : 'Enhance Text',
                              outlined: false,
                              onTap: busy ? null : _enhanceNotes,
                            ),
                          ],
                        ),
                      );
                    }),
                    // const _ReminderBanner(),
                    const SizedBox(height: 20),
                    Obx(() => AGHGradientButton(
                          label: controller.isSchedulingSession.value
                              ? 'Scheduling…'
                              : 'Schedule Session',
                          onPressed: controller.isSchedulingSession.value
                              ? null
                              : _submitSchedule,
                        )),
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

class _MemberCard extends StatelessWidget {
  final String name;
  final String last;
  final String role;
  const _MemberCard({required this.name, required this.last, this.role = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AGHColors.gradientSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AGHColors.purple.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          AGHAvatar(name: name, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (role.trim().isNotEmpty) ...[
                  Text(
                    role.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AGHColors.textSoft,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AGHColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Last session · $last',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AGHColors.textSoft,
                  ),
                ),
              ],
            ),
          ),
          // const AGHStatusChip(kind: AGHStatus.due, label: 'Due'),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color:
              selected ? AGHColors.pink.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AGHColors.pink : AGHColors.line,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? AGHColors.pink : AGHColors.textSoft,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? AGHColors.pink : AGHColors.textSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesActionButton extends StatelessWidget {
  final String label;
  final bool outlined;
  final VoidCallback? onTap;

  const _NotesActionButton({
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

class _ReminderBanner extends StatelessWidget {
  const _ReminderBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3FB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.schedule, size: 18, color: AGHColors.purple),
          SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 11.5,
                  color: AGHColors.textSoft,
                  height: 1.45,
                ),
                children: [
                  TextSpan(text: 'A '),
                  TextSpan(
                    text: 'same-day reminder',
                    style: TextStyle(
                      color: AGHColors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' will be sent to both you and the member in Karma & CRM.',
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
