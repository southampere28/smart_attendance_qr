import 'package:absensi_qr/configs/api_constant.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ScheduleQrTeacherController extends GetxController {
  final EndpointService _httpService = Get.find<EndpointService>();

  DateTime dateNow = DateTime.now();
  String get dateNowFormatted => AppUtil.formatDateIndonesia(dateNow);

  String? codeQR;
  String? subjectName;
  String? dateSchedule;
  BigInt? idSchedule;

  @override
  void onInit() {
    super.onInit();

    final argument = Get.arguments as Map<String, dynamic>?;

    if (argument != null) {
      final String? subjectName = argument['subjectName'];
      final String? codeQR = argument['codeQR'];
      final String? dateSchedule = argument['dateSchedule'];
      final dynamic idScheduleRaw = argument['idSchedule'];

      BigInt? idSchedule;
      if (idScheduleRaw is BigInt) {
        idSchedule = idScheduleRaw;
      } else if (idScheduleRaw is int) {
        idSchedule = BigInt.from(idScheduleRaw);
      } else if (idScheduleRaw != null) {
        idSchedule = BigInt.tryParse(idScheduleRaw.toString());
      }

      this.subjectName = subjectName;
      this.codeQR = codeQR;
      this.dateSchedule = dateSchedule;
      this.idSchedule = idSchedule;

      print('Received arguments:');
      print('Subject Name: $subjectName');
      print('Code QR: $codeQR');
      print('Date Schedule: $dateSchedule');
      print('ID Schedule: $idSchedule');
    } else {
      print('No arguments received.');
    }
  }

  void copyCodeQRToClipboard() async {
    if (idSchedule != null) {
      // fetch dynamic url from API
      final apiResult = await _httpService.generateScheduleQrCode(idSchedule.toString());

      if (apiResult.success && apiResult.data != null) {
        final scheduleQrLink = apiResult.data!['url'] as String;
        Clipboard.setData(ClipboardData(text: scheduleQrLink));
        Get.snackbar('Sukses', 'Kode QR berhasil disalin ke clipboard');
      } else {
        Get.snackbar('Error', 'Gagal mengambil link QR');
      }
    }
  }
}
