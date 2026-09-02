// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karma/Controller/aghController.dart';
import 'package:karma/Widgets/AppBarWidget.dart';
import 'package:karma/Constants/dataInfo.dart';
import 'AGHTheme.dart';
import 'AGHWidgets.dart';
import 'AGHScheduleSession.dart';
import 'AGHCompleted.dart';
import 'AGHCheckIn.dart';
import 'AGHOutcome.dart';

/// Captain dashboard — entry point into the AGH module.
/// Tab 1 (Upcoming) is the default view.
class AGHDashboard extends StatefulWidget {
  const AGHDashboard({super.key});

  @override
  State<AGHDashboard> createState() => _AGHDashboardState();
}

class _AGHDashboardState extends State<AGHDashboard> {
  late final AGHController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<AGHController>()
        ? Get.find<AGHController>()
        : Get.put(AGHController(), permanent: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (DataInfo.userId.value.isNotEmpty) {
        controller.fetchUpcoming();
      }
    });
  }

  /// Other tabs return to Upcoming first; Upcoming exits the screen.
  void _handleBack() {
    if (controller.activeTab.value != 'Upcoming') {
      controller.setTab('Upcoming');
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    const tabs = ['Upcoming', 'Scheduled', 'Pending', 'Completed'];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: AGHColors.pageBg,
        appBar: AppBarWidget(
          onBackPress: _handleBack,
          title: 'Antra Golden Hour',
          onInfo: () => showAGHSchedulingPlan(context),
        ),
        body: Column(
        children: [
          Obx(() => AGHTabs(
                items: tabs,
                active: controller.activeTab.value,
                onChanged: controller.setTab,
              )),
          Expanded(
            child: Obx(() {
              switch (controller.activeTab.value) {
                case 'Scheduled':
                  return _ScheduledTab(controller: controller);
                case 'Pending':
                  return _PendingTab(controller: controller);
                case 'Completed':
                  return const AGHCompletedBody();
                case 'Upcoming':
                  return _UpcomingTab(controller: controller);
                default:
                  return _UpcomingTab(controller: controller);
              }
            }),
          ),
        ],
        ),
      ),
    );
  }
}

class _UpcomingTab extends StatelessWidget {
  final AGHController controller;
  const _UpcomingTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isCaptain = DataInfo.tcId.value == '7';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              if (isCaptain) ...[
                Expanded(child: _UserFilterButton(controller: controller)),
                const SizedBox(width: 8),
              ],
              Expanded(child: _DateRangeFilterButton(controller: controller)),
              const SizedBox(width: 8),
              Expanded(child: _StatusFilterButton(controller: controller)),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingUpcoming.value &&
                controller.upcoming.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: AGHColors.pink),
              );
            }
            final list = controller.filteredUpcoming;
            final hasFilters = controller.upcomingUser.value.isNotEmpty ||
                controller.upcomingDatePreset.value.isNotEmpty ||
                controller.upcomingFilter.value != 'All';
            return RefreshIndicator(
              color: AGHColors.pink,
              onRefresh: controller.fetchUpcoming,
              child: list.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 80),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              hasFilters
                                  ? 'No sessions match the selected filters.'
                                  : 'No upcoming sessions found.',
                              style: const TextStyle(
                                  color: AGHColors.textSoft, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: list.length,
                      itemBuilder: (_, index) =>
                          _UpcomingCard(session: list[index]),
                    ),
            );
          }),
        ),
      ], 
    );
  }
}

class _UserFilterButton extends StatelessWidget {
  final AGHController controller;
  const _UserFilterButton({required this.controller});

  Future<void> _pick(BuildContext context) async {
    final names = controller.upcomingUserNames;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Filter by User',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AGHColors.text,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: AGHColors.line),
              ListTile(
                leading: const Icon(Icons.people_outline,
                    color: AGHColors.textSoft, size: 20),
                title:
                    const Text('All Users', style: TextStyle(fontSize: 13.5)),
                onTap: () {
                  controller.clearUpcomingUser();
                  Navigator.of(ctx).pop();
                },
              ),
              const Divider(height: 1, color: AGHColors.line),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: names.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AGHColors.line),
                  itemBuilder: (_, i) {
                    final n = names[i];
                    final selected = controller.upcomingUser.value == n;
                    return ListTile(
                      leading: AGHAvatar(name: n, size: 32),
                      title: Text(n, style: const TextStyle(fontSize: 13.5)),
                      trailing: selected
                          ? const Icon(Icons.check,
                              color: AGHColors.pink, size: 18)
                          : null,
                      onTap: () {
                        controller.setUpcomingUser(n);
                        Navigator.of(ctx).pop();
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.upcomingUser.value;
      final hasValue = user.isNotEmpty;
      return _FilterPill(
        label: hasValue ? 'User: $user' : 'User: All',
        trailingIcon: Icons.keyboard_arrow_down,
        active: hasValue,
        onTap: () => _pick(context),
      );
    });
  }
}

class _DateRangeFilterButton extends StatelessWidget {
  final AGHController controller;
  const _DateRangeFilterButton({required this.controller});

  static const _presets = ['Today', 'Next 5 days', 'Next 10 days', 'Custom'];

  Future<void> _pickCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final initial = controller.upcomingDatePreset.value == 'Custom'
        ? controller.upcomingDateRange.value
        : null;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      initialDateRange: initial,
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AGHColors.pink,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AGHColors.text,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      controller.setUpcomingCustomRange(picked);
    }
  }

  Future<void> _pick(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Filter by Date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AGHColors.text,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: AGHColors.line),
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined,
                    color: AGHColors.textSoft, size: 20),
                title: const Text('Any date', style: TextStyle(fontSize: 13.5)),
                onTap: () {
                  controller.clearUpcomingDateRange();
                  Navigator.of(ctx).pop();
                },
              ),
              const Divider(height: 1, color: AGHColors.line),
              for (final p in _presets) ...[
                Obx(() {
                  final selected = controller.upcomingDatePreset.value == p;
                  return ListTile(
                    title: Text(p, style: const TextStyle(fontSize: 13.5)),
                    trailing: selected
                        ? const Icon(Icons.check,
                            color: AGHColors.pink, size: 18)
                        : null,
                    onTap: () async {
                      Navigator.of(ctx).pop();
                      if (p == 'Custom') {
                        await _pickCustomRange(context);
                      } else {
                        controller.setUpcomingDatePreset(p);
                      }
                    },
                  );
                }),
                const Divider(height: 1, color: AGHColors.line),
              ],
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  String _format(DateTimeRange r) {
    const m = [
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
    String fmt(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]}';
    return '${fmt(r.start)}–${fmt(r.end)}';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final preset = controller.upcomingDatePreset.value;
      final range = controller.upcomingDateRange.value;
      final hasValue = preset.isNotEmpty;
      String label;
      if (preset == 'Custom' && range != null) {
        label = _format(range);
      } else if (hasValue) {
        label = preset;
      } else {
        label = 'Date: Range';
      }
      return _FilterPill(
        label: label,
        trailingIcon: Icons.keyboard_arrow_down,
        active: hasValue,
        onTap: () => _pick(context),
      );
    });
  }
}

class _StatusFilterButton extends StatelessWidget {
  final AGHController controller;
  const _StatusFilterButton({required this.controller});

  static const _options = ['All', 'Due Soon', 'Missed', 'Upcoming'];

  Future<void> _pick(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Filter by Status',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AGHColors.text,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: AGHColors.line),
              for (final s in _options) ...[
                Obx(() {
                  final selected = controller.upcomingFilter.value == s;
                  return ListTile(
                    title: Text(s, style: const TextStyle(fontSize: 13.5)),
                    trailing: selected
                        ? const Icon(Icons.check,
                            color: AGHColors.pink, size: 18)
                        : null,
                    onTap: () {
                      controller.setUpcomingFilter(s);
                      Navigator.of(ctx).pop();
                    },
                  );
                }),
                const Divider(height: 1, color: AGHColors.line),
              ],
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final value = controller.upcomingFilter.value;
      final hasValue = value != 'All';
      return _FilterPill(
        label: hasValue ? value : 'Status',
        trailingIcon: Icons.tune,
        active: hasValue,
        onTap: () => _pick(context),
      );
    });
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final IconData trailingIcon;
  final bool active;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.trailingIcon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: active ? AGHColors.pink.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: active ? AGHColors.pink : AGHColors.line),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: active ? AGHColors.pink : AGHColors.textSoft,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              trailingIcon,
              size: 14,
              color: active ? AGHColors.pink : AGHColors.textSoft,
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  final AGHSession session;
  const _UpcomingCard({required this.session});

  AGHStatus _statusKind() {
    switch (session.status) {
      case AGHMemberStatus.due:
        return AGHStatus.due;
      case AGHMemberStatus.missed:
        return AGHStatus.missed;
      case AGHMemberStatus.upcoming:
        return AGHStatus.upcoming;
      case AGHMemberStatus.pending:
        return AGHStatus.due;
    }
  }

  String _statusLabel() {
    switch (session.status) {
      case AGHMemberStatus.due:
        return 'Due Soon';
      case AGHMemberStatus.missed:
        return 'Missed';
      case AGHMemberStatus.upcoming:
        return 'Upcoming';
      case AGHMemberStatus.pending:
        return 'Pending';
    }
  }


  @override
  Widget build(BuildContext context) {
    final isCaptain = DataInfo.tcId.value == '7';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AGHColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14141428),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CardAvatar(name: session.name),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AGHColors.text,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              session.role.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AGHColors.textSoft,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          AGHStatusChip(
                            kind: _statusKind(),
                            label: _statusLabel(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AGHColors.line),
                  bottom: BorderSide(color: AGHColors.line),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _DatePair(label: 'NEXT DUE', value: session.next),
                  ),
                  Expanded(
                    child:
                        _DatePair(label: 'LAST SESSION', value: session.last),
                  ),
                  Expanded(
                    child: _DatePair(
                        label: 'AGE', value: "${session.age.toString()} M"),
                  ),
                ],
              ),
            ),
            if (isCaptain) ...[
              const SizedBox(height: 14),
              AGHGradientButton(
                label: 'Schedule Session',
                icon: Icons.calendar_today_outlined,
                borderRadius: 12,
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: () => Get.to(() => AGHScheduleSession(
                      memberUserId: session.userId,
                      memberName: session.name,
                      memberLast: session.last,
                      memberRole: session.role,
                      expireDate: session.expireDate,
                    )),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CardAvatar extends StatelessWidget {
  final String name;
  const _CardAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AGHColors.gradient,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: AGHColors.purple.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(name),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _initials(String name) {
    return name
        .trim()
        .split(RegExp(r'\s+'))
        .take(2)
        .map((w) => w.isNotEmpty ? w[0] : '')
        .join()
        .toUpperCase();
  }
}

class _DatePair extends StatelessWidget {
  final String label;
  final String value;
  const _DatePair({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AGHColors.textFaint,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AGHColors.text,
          ),
        ),
      ],
    );
  }
}

class _ScheduledTab extends StatelessWidget {
  final AGHController controller;
  const _ScheduledTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.scheduled;
      return RefreshIndicator(
        color: AGHColors.pink,
        onRefresh: controller.fetchUpcoming,
        child: list.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 80),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No scheduled sessions yet.',
                        style:
                            TextStyle(color: AGHColors.textSoft, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                itemCount: list.length + 1,
                itemBuilder: (_, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(4, 6, 4, 8),
                      child: Text(
                        'SCHEDULED · ${list.length} SESSION${list.length == 1 ? '' : 'S'}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AGHColors.textFaint,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    );
                  }
                  return _ScheduledCard(session: list[index - 1]);
                },
              ),
      );
    });
  }
}

class _ScheduledCard extends StatelessWidget {
  final AGHScheduledSession session;
  const _ScheduledCard({required this.session});

  /// Today → Today, before today → Missed, future → Scheduled.
  ({AGHStatus kind, String label}) _statusChip() {
    final at = session.scheduledAt;
    if (at == null) {
      return (kind: AGHStatus.scheduled, label: 'Scheduled');
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(at.year, at.month, at.day);
    final diff = date.difference(today).inDays;
    if (diff == 0) return (kind: AGHStatus.live, label: 'Today');
    if (diff < 0) return (kind: AGHStatus.missed, label: 'Missed');
    return (kind: AGHStatus.scheduled, label: 'Scheduled');
  }

  /// Who still needs to check in-out. Returns null when both have checked in
  /// (nothing pending) or neither has (fresh session — nothing to show).
  String? _pendingFromLabel() {
    final captainDone = session.captainStart.trim().isNotEmpty;
    final memberDone = session.userStart.trim().isNotEmpty;
    if (captainDone == memberDone) return null;
    final isCaptain = DataInfo.tcId.value == '7';
    if (isCaptain) {
      return memberDone
          ? 'Check Out pending from you'
          : 'Check Out pending from ${session.name}';
    }
    return memberDone
        ? 'Check Out pending from '
            '${session.captainName.isNotEmpty ? session.captainName : 'captain'}'
        : 'Check Out pending from you';
  }

  @override
  Widget build(BuildContext context) {
    final isCaptain = DataInfo.tcId.value == '7';
    final status = _statusChip();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AGHColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A141428),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              AGHAvatar(name: session.name),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AGHColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${session.date} · ${session.time} · ${session.mode}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AGHColors.textSoft,
                      ),
                    ),
                  ],
                ),
              ),
              AGHStatusChip(
                kind: status.kind,
                label: status.label,
              ),
            ],
          ),
          if (_pendingFromLabel() != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.hourglass_top,
                    size: 14, color: AGHColors.textSoft),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _pendingFromLabel()!,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AGHColors.textSoft,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isCaptain)
                TextButton.icon(
                  onPressed: () => Get.to(() => AGHScheduleSession(
                        memberUserId: session.userId,
                        memberName: session.name,
                        memberLast: session.date,
                        memberTopic: session.topicName,
                        meetingId: session.meetingId,
                        expireDate: session.expireDate,
                        memberNotes: session.notes,
                        memberMode: session.mode,
                        scheduledAt: session.scheduledAt,
                      )),
                  icon: const Icon(Icons.event_repeat,
                      size: 16, color: AGHColors.purple),
                  label: const Text(
                    'Reschedule',
                    style: TextStyle(
                      color: AGHColors.purple,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              const Spacer(),
              AGHActionPill(
                label: session.joinable ? 'Start Session →' : 'Join Room →',
                onPressed: () {
                  final at = session.scheduledAt;
                  if (at != null) {
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final date = DateTime(at.year, at.month, at.day);
                    // Joining is only allowed on/after the scheduled date.
                    if (date.isAfter(today)) {
                      Get.snackbar(
                        'AGH Session',
                        'This session is scheduled for later. Please wait for '
                            'the scheduled time or reschedule to join now.',
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(12),
                        borderRadius: 10,
                        duration: const Duration(seconds: 3),
                      );
                      return;
                    }
                  }
                  Get.find<AGHController>().startActiveSession(session);
                  Get.to(() => const AGHCheckIn());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PendingTab extends StatelessWidget {
  final AGHController controller;
  const _PendingTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.pending;
      return RefreshIndicator(
        color: AGHColors.pink,
        onRefresh: controller.fetchUpcoming,
        child: list.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 80),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No pending sessions.',
                        style:
                            TextStyle(color: AGHColors.textSoft, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                itemCount: list.length + 1,
                itemBuilder: (_, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(4, 6, 4, 8),
                      child: Text(
                        'PENDING · ${list.length} SESSION${list.length == 1 ? '' : 'S'}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AGHColors.textFaint,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    );
                  }
                  return _PendingCard(session: list[index - 1]);
                },
              ),
      );
    });
  }
}

class _PendingCard extends StatelessWidget {
  final AGHScheduledSession session;
  const _PendingCard({required this.session});

  void _openCheckIn() {
    final controller = Get.find<AGHController>();
    controller.startActiveSession(session);

    // Pending tile always opens the Outcome screen. Existing remarks are
    // prefilled so each side sees what's already submitted; the Outcome screen
    // shows a "Submit Remark" box when the logged-in user's own remark is empty.
    controller.memberLearningSubmitted.value =
        session.memberRemark.trim().isNotEmpty;
    if (session.captainRemark.trim().isNotEmpty) {
      controller.captainOutput.value = session.captainRemark;
    }
    if (session.memberRemark.trim().isNotEmpty) {
      controller.memberOutput.value = session.memberRemark;
    }
    Get.to(() => const AGHOutcome());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _openCheckIn,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AGHColors.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A141428),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                AGHAvatar(name: session.name),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AGHColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${session.date} · ${session.time} · ${session.mode}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AGHColors.textSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const AGHStatusChip(
                  kind: AGHStatus.due,
                  label: 'Pending',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Text(
                //         'STATUS',
                //         style: TextStyle(
                //           fontSize: 10.5,
                //           color: AGHColors.textFaint,
                //         ),
                //       ),
                //       const SizedBox(height: 2),
                //       Text(
                //         session.startsIn,
                //         style: const TextStyle(
                //           fontSize: 12.5,
                //           fontWeight: FontWeight.w500,
                //           color: AGHColors.text,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                AGHActionPill(
                  label: 'Review →',
                  onPressed: _openCheckIn,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
