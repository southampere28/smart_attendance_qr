import 'package:absensi_qr/utils/app_util.dart';
import 'package:get/get.dart';

class ScheduleQrTeacherController extends GetxController {
  DateTime dateNow = DateTime.now();
  String get dateNowFormatted => AppUtil.formatDateIndonesia(dateNow);

  String? codeQR;
  String? subjectName;

  @override
  void onInit() {
    super.onInit();

    final argument = Get.arguments as Map<String, dynamic>?;

    if (argument != null) {
      final String? subjectName = argument['subjectName'];
      final String? codeQR = argument['codeQR'];

      this.subjectName = subjectName;
      this.codeQR = codeQR;

      print('Received arguments:');
      print('Subject Name: $subjectName');
      print('Code QR: $codeQR');

    } else {
      print('No arguments received.');
    }
  }
}
