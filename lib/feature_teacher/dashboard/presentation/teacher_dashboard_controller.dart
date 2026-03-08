import 'package:absensi_qr/utils/app_util.dart';
import 'package:get/get.dart';

class  TeacherDashboardController extends GetxController {
  
  DateTime dateNow = DateTime.now();

  String get dateNowFormatted => AppUtil.formatDateIndonesia(dateNow);
  
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}