import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Aktivitas',
            style: AppFontStyle.titleText,
          ),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
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
            Expanded(child: SingleChildScrollView(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final notifications = controller.filteredNotifications;
                if (notifications.isEmpty) {
                  return const Center(child: Text('Tidak ada notifikasi'));
                }
                return Column(
                  children: notifications
                      .map((notification) => _cardNotification(
                            notification.title,
                            notification.body,
                            notification.createdAt ?? DateTime.now(),
                            notification.type,
                          ))
                      .toList(),
                );
              }),
            )),
          ],
        ));
  }

  Widget _cardNotification(String title, String message, DateTime dateTime,
      NotificationTypeEnum type) {
    return GestureDetector(
      onTap: () {
        final int? navIndex = _mapTypeToNavIndex(type);
        if (navIndex != null) {
          Get.find<NavigationTeacherController>().changePage(navIndex);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title,
                      style: AppFontStyle.primaryText
                          .copyWith(fontWeight: FontWeight.w500)),
                ),
                SpacingSize.spacingMDWidth,
                Text(
                  AppUtil.formatTime(dateTime),
                  style: AppFontStyle.primaryText
                      .copyWith(color: AppColor.colorTextSubtitle),
                ),
              ],
            ),
            SpacingSize.spacingXSHeight,
            Text(message, style: AppFontStyle.subTitleText),
            SpacingSize.spacingXSHeight,
            Divider(
              color: AppColor.colorOutlineBoxinput,
            )
          ],
        ),
      ),
    );
  }

  int? _mapTypeToNavIndex(NotificationTypeEnum type) {
    switch (type) {
      case NotificationTypeEnum.permission:
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
        margin: const EdgeInsets.only(right: 6),
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
