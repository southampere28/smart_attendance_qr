import 'dart:developer';

import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/domain/enum/notification_type_enum.dart';
import 'package:absensi_qr/feature_teacher/navigation/presentation/navigation_teacher_controller.dart';
import 'package:absensi_qr/feature_teacher/teacher_activity/presentation/activity_teacher_controller.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityTeacherPage extends StatelessWidget {
  const ActivityTeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActivityTeacherController>();
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.backgroundColor,
          automaticallyImplyLeading: false,
          title: Text(
            'Aktivitas',
            style: AppFontStyle.titleText,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchTeacherActivity();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(() => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          controller.filterItems.length,
                          (index) => _buttonFilter(
                            controller.filterItems[index].label,
                            controller.filterItems[index].icon,
                            () => controller.selectFilter(index),
                            controller.selectedFilterIndex.value == index,
                          ),
                        ),
                      )),
                ),
              ),
              SliverToBoxAdapter(child: SpacingSize.spacingBaseHeight),
              SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final notifications = controller.filteredNotifications;
                  if (notifications.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Center(child: Text('Tidak ada Aktivitas')),
                      ],
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildGroupedNotifications(notifications),
                    ),
                  );
                }),
              ),
            ],
          ),
        ));
  }

  List<Widget> _buildGroupedNotifications(notifications) {
    final Map<DateTime, List> groupedNotifications = {};

    for (final notification in notifications) {
      final createdAt = notification.createdAt;
      if (createdAt == null) continue;
      final dayKey = DateTime(createdAt.year, createdAt.month, createdAt.day);
      groupedNotifications.putIfAbsent(dayKey, () => []);
      groupedNotifications[dayKey]!.add(notification);
    }

    final sortedDays = groupedNotifications.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return sortedDays
        .map(
          (day) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDayLabel(day),
                style: AppFontStyle.primaryText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SpacingSize.spacingBaseHeight,
              ...groupedNotifications[day]!
                  .map(
                    (notification) => _cardNotification(
                      notification.title,
                      notification.body,
                      notification.createdAt ?? DateTime.now(),
                      notification.type,
                    ),
                  )
                  .toList(),
            ],
          ),
        )
        .toList();
  }

  String _formatDayLabel(DateTime dateTime) {
    final today = DateTime.now();
    final currentDay = DateTime(today.year, today.month, today.day);
    final targetDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final diffDays = currentDay.difference(targetDay).inDays;

    if (diffDays == 0) return 'Hari ini';
    if (diffDays == 1) return 'Kemarin';
    return AppUtil.formatDateIndonesia(dateTime);
  }

  Widget _cardNotification(String title, String message, DateTime dateTime,
      NotificationTypeEnum type) {
    final iconPath = AssetConstant.getNotificationIconByType(type.dbValue);

    return GestureDetector(
      onTap: () {
        final int? navIndex = _mapTypeToNavIndex(type);
        if (navIndex != null) {
          Get.find<NavigationTeacherController>().changePage(navIndex);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // map type to icon
                Image.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    log('Error loading icon for type ${type.dbValue}: $error');
                    return Icon(Icons.notifications,
                        color: AppColor.primaryColor, size: 24);
                  },
                ),
                SpacingSize.spacingMDWidth,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: AppFontStyle.primaryText
                              .copyWith(fontWeight: FontWeight.bold)),
                      SpacingSize.spacingXSHeight,
                      Text(message, style: AppFontStyle.subTitleText),
                    ],
                  ),
                ),
                SpacingSize.spacingMDWidth,
                Text(
                  AppUtil.formatTime(dateTime),
                  style: AppFontStyle.primaryText
                      .copyWith(color: AppColor.colorTextSubtitle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int? _mapTypeToNavIndex(NotificationTypeEnum type) {
    switch (type) {
      case NotificationTypeEnum.permission ||
            NotificationTypeEnum.permissionAccepted ||
            NotificationTypeEnum.permissionRejected:
        return 1;
      case NotificationTypeEnum.attendanceViolation:
        return 2;
      default:
        return null;
    }
  }

  Widget _buttonFilter(
      String label, IconData icon, VoidCallback onPressed, bool isActive) {
    final color =
        isActive ? AppColor.primaryColor : AppColor.colorOutlineBoxinput;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColor.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: color,
              size: 16,
            ),
            SpacingSize.spacingXSWidth,
            Text(label, style: AppFontStyle.primaryText.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
