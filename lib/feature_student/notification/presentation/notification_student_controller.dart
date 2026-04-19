import 'dart:developer';

import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/models/notification_model.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class NotificationStudentController extends GetxController {
  // service controller
  final MainController mainController = Get.find<MainController>();
  final EndpointService _httpService = Get.find<EndpointService>();

  // testing field for topic name
  final TextEditingController topicController =
      TextEditingController(text: 'student_notifications');

  // flags here
  final RxBool isLoading = false.obs;

  final RxList<NotificationModel> dataNotifications = <NotificationModel>[].obs;

  // dummy data only, sorted by date time descending.
  // final dummyNotifications = [
  //   NotificationModel(
  //       title: 'Perizinan Diterima',
  //       message: 'Permintaan perizinan Anda telah diterima.',
  //       dateTime: DateTime(2026, 4, 10, 10, 0, 0)),
  //   NotificationModel(
  //       title: 'Tugas Kelas',
  //       message: 'Tugas kelas IPA baca buku halaman 10-20.',
  //       dateTime: DateTime(2026, 4, 10, 10, 0, 0)),
  //   NotificationModel(
  //       title: 'Perizinan Ditolak',
  //       message: 'Permintaan perizinan Anda telah ditolak.',
  //       dateTime: DateTime(2026, 4, 9, 14, 30, 0)),
  //   NotificationModel(
  //       title: 'Pengumuman',
  //       message: 'Jadwal ujian akhir semester telah diumumkan.',
  //       dateTime: DateTime(2026, 4, 8, 9, 0, 0)),
  //   NotificationModel(
  //       title: 'Tugas Kelas',
  //       message: 'Tugas kelas Matematika, kerjakan soal nomor 1-10.',
  //       dateTime: DateTime(2026, 4, 7, 11, 0, 0))
  // ].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchNotifications();
  }


  /// future function 
  // get notification data from endpoint laravel.
  Future<void> fetchNotifications() async {
    isLoading.value = true;

    // fetch notifications for 1 month, endDate is today.
    final DateTime endDate = DateTime.now();
    final DateTime startDate = endDate.subtract(Duration(days: 30));
    
    // convert to string with format yyyy-MM-dd
    final String startDateStr = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final String endDateStr = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

    final result = await _httpService.getStudentNotifications(startDateStr, endDateStr);

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
        log('Loaded ${items.length} notification items');
      } else {
        dataNotifications.clear();
      }
    } else {
      dataNotifications.clear();
    }
    isLoading.value = false;
  }



}
