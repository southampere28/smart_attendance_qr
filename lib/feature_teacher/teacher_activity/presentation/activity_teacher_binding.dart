import 'package:get/get.dart';
import 'package:absensi_qr/feature_teacher/teacher_activity/presentation/activity_teacher_controller.dart';

class ActivityTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityTeacherController>(
      () => ActivityTeacherController(),
    );
  }

}