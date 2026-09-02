// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karma/Controller/aghController.dart';

import 'AGHTheme.dart';
import 'AGHWidgets.dart';

/// AGH notification list — matches the notification taxonomy from the PRD.
class AGHNotifications extends StatelessWidget {
  const AGHNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AGHController>();




    const filters = ['All', 'Unread', 'Sessions'];

    return Scaffold(
      backgroundColor: AGHColors.pageBg,
      body: Column(
        children: [
          AGHHeader(
            title: 'Notifications',
            trailing: GestureDetector(
              onTap: () {},
              child: const Text(
                'Clear',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: Obx(() {
              final active = controller.notificationFilter.value;
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => AGHFilterChip(
                  label: filters[i],
                  selected: active == filters[i],
                  onTap: () => controller.setNotificationFilter(filters[i]),
                ),
              );
            }),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: controller.notifications.length,
              itemBuilder: (_, i) =>
                  _NotificationTile(item: controller.notifications[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AGHNotification item;
  const _NotificationTile({required this.item});

  Color get _kindColor {
    switch (item.kind) {
      case AGHNotificationKind.pink:
        return AGHColors.pink;
      case AGHNotificationKind.warn:
        return AGHColors.warn;
      case AGHNotificationKind.success:
        return AGHColors.success;
      case AGHNotificationKind.purple:
        return AGHColors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: item.read ? 0.75 : 1.0,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AGHColors.line),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _kindColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.notifications_none_outlined,
                    size: 16,
                    color: _kindColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AGHColors.text,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.time,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AGHColors.textFaint,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.message,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AGHColors.textSoft,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!item.read)
            Positioned(
              left: -4,
              top: 0,
              bottom: 8,
              child: Center(
                child: Container(
                  width: 3,
                  height: 24,
                  decoration: const BoxDecoration(
                    gradient: AGHColors.gradient,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
