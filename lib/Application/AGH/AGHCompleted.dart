// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karma/Controller/aghController.dart';

import 'AGHTheme.dart';
import 'AGHWidgets.dart';
import 'AGHOutcome.dart';

/// Standalone wrapper so Completed can be opened as its own page.
class AGHCompletedPage extends StatelessWidget {
  const AGHCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AGHColors.pageBg,
      body: Column(
        children: [
          AGHHeader(title: 'Antra Golden Hour', showBack: false),
          AGHTabs(
            items: ['Upcoming', 'Scheduled', 'Completed'],
            active: 'Completed',
          ),
          Expanded(child: AGHCompletedBody()),
        ],
      ),
    );
  }
}

/// Body of the Completed tab — reused inside the dashboard's tab switcher.
class AGHCompletedBody extends StatelessWidget {
  const AGHCompletedBody({super.key});

  static const _filters = ['By member', 'Date range'];
  static const _datePresets = ['Today', 'Last 5 days', 'Last 10 days', 'Custom'];

  Future<void> _pickMember(BuildContext context) async {
    final controller = Get.find<AGHController>();
    final names = controller.completedUserNames;
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
                    'Filter by Member',
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
                title: const Text('All Members',
                    style: TextStyle(fontSize: 13.5)),
                onTap: () {
                  controller.clearCompletedFilters();
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
                    final selected = controller.completedUser.value == n;
                    return ListTile(
                      leading: AGHAvatar(name: n, size: 32),
                      title: Text(n, style: const TextStyle(fontSize: 13.5)),
                      trailing: selected
                          ? const Icon(Icons.check,
                              color: AGHColors.pink, size: 18)
                          : null,
                      onTap: () {
                        controller.setCompletedUser(n);
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

  Future<void> _pickCustomRange(BuildContext context) async {
    final controller = Get.find<AGHController>();
    final now = DateTime.now();
    final initial = controller.completedDatePreset.value == 'Custom'
        ? controller.completedDateRange.value
        : null;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      initialDateRange: initial,
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
    if (picked != null) controller.setCompletedDateRange(picked);
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final controller = Get.find<AGHController>();
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
                title:
                    const Text('Any date', style: TextStyle(fontSize: 13.5)),
                onTap: () {
                  controller.clearCompletedDateRange();
                  Navigator.of(ctx).pop();
                },
              ),
              const Divider(height: 1, color: AGHColors.line),
              for (final p in _datePresets) ...[
                Obx(() {
                  final selected = controller.completedDatePreset.value == p;
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
                        controller.setCompletedDatePreset(p);
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

  void _onFilterTap(BuildContext context, String filter) {
    final controller = Get.find<AGHController>();
    switch (filter) {
      case 'By member':
        _pickMember(context);
        break;
      case 'Date range':
        _pickDateRange(context);
        break;
      default:
        controller.setCompletedFilter(filter);
    }
  }

  String _filterLabel(AGHController controller, String filter) {
    if (filter == 'By member') {
      final u = controller.completedUser.value;
      return u.isEmpty ? 'Member: All' : 'Member: $u';
    }
    if (filter == 'Date range') {
      final preset = controller.completedDatePreset.value;
      final r = controller.completedDateRange.value;
      if (preset == 'Custom' && r != null) {
        const m = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        String fmt(DateTime d) =>
            '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]}';
        return '${fmt(r.start)}–${fmt(r.end)}';
      }
      if (preset.isNotEmpty) return preset;
      return 'Date: Range';
    }
    return filter;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AGHController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => Obx(
              () => AGHFilterChip(
                label: _filterLabel(controller, _filters[i]),
                selected: controller.completedFilter.value == _filters[i],
                showCaret: true,
                onTap: () => _onFilterTap(context, _filters[i]),
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            final list = controller.filteredCompleted;
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
                              'No completed sessions match the selected filter.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AGHColors.textSoft, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: list.length,
                      itemBuilder: (_, i) => _CompletedRow(session: list[i]),
                    ),
            );
          }),
        ),
      ],
    );
  }
}





class _CompletedRow extends StatelessWidget {
  final AGHCompletedSession session;
  const _CompletedRow({required this.session});

  void _openOutcome() {
    final controller = Get.find<AGHController>();
    controller.startActiveSession(AGHScheduledSession(
      name: session.name,
      date: session.date,
      time: '',
      mode: session.mode,
      startsIn: 'Completed',
      topicName: session.topicName,
      captainRemark: session.captainRemark,
      memberRemark: session.memberRemark,
      captainRemarkAt: session.captainRemarkAt,
      memberRemarkAt: session.memberRemarkAt,
      notes: session.notes,
      captainStart: session.captainStart,
      captainEnd: session.captainEnd,
      userStart: session.userStart,
      userEnd: session.userEnd,
    ));
    controller.captainOutput.value = session.captainRemark;
    controller.memberOutput.value = session.memberRemark;
    controller.memberLearningSubmitted.value =
        session.memberRemark.trim().isNotEmpty;
    Get.to(() => const AGHOutcome());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _openOutcome,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AGHColors.line),
        ),
        child: Row(
          children: [
            AGHAvatar(name: session.name, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.name,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AGHColors.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${session.date} · ${session.duration} · ${session.mode}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AGHColors.textSoft,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AGHColors.successSoft,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check, size: 14, color: AGHColors.success),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AGHColors.textFaint,
            ),
          ],
        ),
      ),
    );
  }
}
