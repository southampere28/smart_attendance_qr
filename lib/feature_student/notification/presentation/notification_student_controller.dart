import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/models/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class NotificationStudentController extends GetxController {
  // service controller
  final MainController mainController = Get.find<MainController>();

  // testing field for topic name
  final TextEditingController topicController =
      TextEditingController(text: 'student_notifications');

  // dummy data only, sorted by date time descending.
  final dummyNotifications = [
    NotificationModel(
        title: 'Perizinan Diterima',
        message: 'Permintaan perizinan Anda telah diterima.',
        dateTime: DateTime(2026, 4, 10, 10, 0, 0)),
    NotificationModel(
        title: 'Tugas Kelas',
        message: 'Tugas kelas IPA baca buku halaman 10-20.',
        dateTime: DateTime(2026, 4, 10, 10, 0, 0)),
    NotificationModel(
        title: 'Perizinan Ditolak',
        message: 'Permintaan perizinan Anda telah ditolak.',
        dateTime: DateTime(2026, 4, 9, 14, 30, 0)),
    NotificationModel(
        title: 'Pengumuman',
        message: 'Jadwal ujian akhir semester telah diumumkan.',
        dateTime: DateTime(2026, 4, 8, 9, 0, 0)),
    NotificationModel(
        title: 'Tugas Kelas',
        message: 'Tugas kelas Matematika, kerjakan soal nomor 1-10.',
        dateTime: DateTime(2026, 4, 7, 11, 0, 0))
  ].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
