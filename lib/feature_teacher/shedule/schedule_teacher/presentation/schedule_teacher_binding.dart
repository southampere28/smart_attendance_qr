import 'package:absensi_qr/feature_teacher/shedule/schedule_teacher/presentation/schedule_teacher_controller.dart';
import 'package:get/get.dart';

class ScheduleTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScheduleTeacherController());
  }
}