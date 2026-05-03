import 'dart:developer';

import 'package:absensi_qr/domain/enum/notification_type_enum.dart';
import 'package:absensi_qr/models/notification_model.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterItem {
  final String label;
  final IconData icon;

  const FilterItem({required this.label, required this.icon});
}

class ActivityTeacherController extends GetxController {
  // service with controller
  final EndpointService _httpService = Get.find<EndpointService>();

  final List<FilterItem> filterItems = const [
    FilterItem(label: 'Semua', icon: Icons.filter_list),
    FilterItem(label: 'Perizinan', icon: Icons.assignment),
    FilterItem(label: 'Pengumuman', icon: Icons.check_circle_outline),
    FilterItem(label: 'Pelaporan', icon: Icons.announcement),
  ];

  // flag
  final RxInt selectedFilterIndex = 0.obs;

  // data here
  final RxList<NotificationModel> dataNotifications = <NotificationModel>[].obs;
  final RxList<NotificationModel> filteredNotifications =
      <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;

  void selectFilter(int index) {
    selectedFilterIndex.value = index;
    _applyFilter(filterItems[index].label);
  }

  void _applyFilter(String label) {
    // TODO: implement filtering logic based on label
    if (label == 'Semua') {
      filteredNotifications.assignAll(dataNotifications);
    } else {
      filteredNotifications.assignAll(
        dataNotifications.where((notification) {
          switch (label) {
            case 'Perizinan':
              return notification.type == NotificationTypeEnum.permission ||
                  notification.type ==
                      NotificationTypeEnum.permissionAccepted ||
                  notification.type == NotificationTypeEnum.permissionRejected;
            case 'Pengumuman':
              return notification.type ==
                      NotificationTypeEnum.announcementForClass ||
                  notification.type ==
                      NotificationTypeEnum.announcementGeneral ||
                  notification.type == NotificationTypeEnum.classCancelled ||
                  notification.type == NotificationTypeEnum.assignment;
            case 'Pelaporan':
              return notification.type ==
                  NotificationTypeEnum.attendanceViolation;
            default:
              return false;
          }
        }).toList(),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTeacherActivity();
  }

  /// future function
  // get notification data from endpoint laravel.
  Future<void> fetchTeacherActivity() async {
    isLoading.value = true;

    // fetch notifications for 1 month, endDate is today.
    final DateTime endDate = DateTime.now();
    final DateTime startDate = endDate.subtract(Duration(days: 30));

    // convert to string with format yyyy-MM-dd
    final String startDateStr =
        '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final String endDateStr =
        '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

    final result = await _httpService.getTeacherActivity(
        startDate: startDateStr, endDate: endDateStr);

    if (result.success) {
      final List<dynamic>? raw = result.data;
      if (raw != null) {
        final items = raw
            .map((e) => NotificationModel.fromMap(e as Map<String, dynamic>))
            .toList();

        // sort by createdAt descending
        items.sort((a, b) {
          return b.createdAt!.compareTo(a.createdAt!);
        });

        dataNotifications.assignAll(items);
        filteredNotifications.assignAll(items);
        log('Loaded ${items.length} notification items');
      } else {
        dataNotifications.clear();
        filteredNotifications.clear();
      }
    } else {
      dataNotifications.clear();
      filteredNotifications.clear();
    }
    isLoading.value = false;
  }
}
