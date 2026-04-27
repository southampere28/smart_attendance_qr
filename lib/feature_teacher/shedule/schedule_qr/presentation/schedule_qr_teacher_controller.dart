import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ScheduleQrTeacherController extends GetxController {
  DateTime dateNow = DateTime.now();
  String get dateNowFormatted => AppUtil.formatDateIndonesia(dateNow);

  String? codeQR;
  String? subjectName;
  String? dateSchedule;

  @override
  void onInit() {
    super.onInit();

    final argument = Get.arguments as Map<String, dynamic>?;

    if (argument != null) {
      final String? subjectName = argument['subjectName'];
      final String? codeQR = argument['codeQR'];
      final String? dateSchedule = argument['dateSchedule'];

      this.subjectName = subjectName;
      this.codeQR = codeQR;
      this.dateSchedule = dateSchedule;

      print('Received arguments:');
      print('Subject Name: $subjectName');
      print('Code QR: $codeQR');

    } else {
      print('No arguments received.');
    }
  }

  void copyCodeQRToClipboard() {
    if (codeQR != null) {
      Clipboard.setData(ClipboardData(text: codeQR!));
      Get.snackbar('Sukses', 'Kode QR berhasil disalin ke clipboard');
    }
  }
}
