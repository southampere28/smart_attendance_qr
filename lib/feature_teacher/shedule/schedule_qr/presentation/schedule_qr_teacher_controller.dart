import 'package:absensi_qr/configs/api_constant.dart';
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
      // url website static, next time change for dynamic using endpoint API
      var scheduleQrLink = "${ApiConstant.scheduleQrURL}/$codeQR";

      Clipboard.setData(ClipboardData(text: scheduleQrLink));
      Get.snackbar('Sukses', 'Kode QR berhasil disalin ke clipboard');
    }
  }
}
