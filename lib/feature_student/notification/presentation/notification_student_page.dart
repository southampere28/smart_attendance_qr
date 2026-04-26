import 'dart:developer';

import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/domain/enum/notification_type_enum.dart';
import 'package:absensi_qr/feature_student/navigation/presentation/navigation_controller.dart';
import 'package:absensi_qr/feature_student/notification/presentation/notification_student_controller.dart';
import 'package:absensi_qr/models/notification_model.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:absensi_qr/features/widgets/textfield_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationStudentPage extends StatelessWidget {
  const NotificationStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationStudentController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Notifikasi',
          style: AppFontStyle.titleText.copyWith(color: Colors.black),
        ),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // each day, show the description like (hari ini, kemarin, 2 hari yang lalu, dst)
              Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: controller.isLoading.value
                        ? [
                            SpacingSize.spacingHugeHeight,
                            Container(
                              width: double.infinity,
                              height: 300,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            )
                          ]
                        : _buildNotificationSections(
                            context, controller.dataNotifications),
                  )),

              SpacingSize.spacingHugeHeight,
              Text('Testing Zone',
                  style: AppFontStyle.primaryText
                      .copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              // field for testing topic name
              // add obx to auto update the text field value when topic name is changed
              TextfieldInputWidget(
                  controller: controller.topicController,
                  hintTxt: 'Enter topic name',
                  keyboardType: TextInputType.text),

              // subscribe and unsubsribe button for testing
              ElevatedButton(
                onPressed: () {
                  controller.mainController.subscribeToNotifications(
                      controller.topicController.text);
                },
                child: Text('Subscribe to Notifications'),
              ),

              ElevatedButton(
                onPressed: () async {
                  final topic = controller.topicController.text;
                  log('Topic: $topic'); // debug print
                  if (topic.isEmpty) {
                    log('Topic kosong!');
                    return;
                  }
                  controller.mainController.unsubscribeFromNotifications(topic);
                },
                child: Text('Unsubscribe from Notifications'),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNotificationSections(
    BuildContext context,
    List<NotificationModel> notifications,
  ) {
    final Map<DateTime, List<NotificationModel>> groupedNotifications = {};

    for (final notification in notifications) {
      final createdAtNotification = notification.createdAt;
      if (createdAtNotification == null) {
        log('Notification with null createdAt: ${notification.title}');
        continue;
      }

      final DateTime dayKey = DateTime(
        createdAtNotification.year,
        createdAtNotification.month,
        createdAtNotification.day,
      );

      groupedNotifications.putIfAbsent(dayKey, () => []);
      groupedNotifications[dayKey]!.add(notification);
    }

    final List<DateTime> sortedDays = groupedNotifications.keys.toList()
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
                      notification.createdAt!,
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
    final DateTime today = DateTime.now();
    final DateTime currentDay = DateTime(today.year, today.month, today.day);
    final DateTime targetDay =
        DateTime(dateTime.year, dateTime.month, dateTime.day);
    final int diffDays = currentDay.difference(targetDay).inDays;

    if (diffDays == 0) {
      return 'Hari ini';
    }

    if (diffDays == 1) {
      return 'Kemarin';
    }

    return AppUtil.formatDateIndonesia(dateTime);
  }

  Widget _cardNotification(String title, String message, DateTime dateTime,
      NotificationTypeEnum type) {
    final iconPath = AssetConstant.getNotificationIconByType(type.dbValue);

    return GestureDetector(
      onTap: () {
        final int? navIndex = _mapTypeToNavIndex(type);
        Get.back();
        if (navIndex != null) {
          Get.find<NavigationController>().changePage(navIndex);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
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
      case NotificationTypeEnum.permission || NotificationTypeEnum.permissionAccepted || NotificationTypeEnum.permissionRejected:
        return 2;
      case NotificationTypeEnum.attendanceViolation:
        return 1;
      default:
        return null;
    }
  }
}
