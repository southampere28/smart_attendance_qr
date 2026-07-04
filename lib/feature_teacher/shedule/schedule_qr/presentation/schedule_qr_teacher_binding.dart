import 'package:absensi_qr/feature_teacher/shedule/schedule_qr/presentation/schedule_qr_teacher_controller.dart';
import 'package:get/get.dart';

class ScheduleQrTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleQrTeacherController>(() => ScheduleQrTeacherController());
  }
}
