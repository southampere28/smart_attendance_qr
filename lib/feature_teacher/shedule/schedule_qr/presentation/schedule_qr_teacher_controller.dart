import 'package:absensi_qr/utils/app_util.dart';
import 'package:get/get.dart';

class ScheduleQrTeacherController extends GetxController {
  
  DateTime dateNow = DateTime.now();
  
  String get dateNowFormatted => AppUtil.formatDateIndonesia(dateNow);

  @override
  void onInit() {
    super.onInit();
  }
}
