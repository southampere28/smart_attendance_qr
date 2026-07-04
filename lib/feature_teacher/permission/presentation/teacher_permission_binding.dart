import 'package:absensi_qr/feature_teacher/permission/presentation/teacher_permission_controller.dart';
import 'package:get/get.dart';

class TeacherPermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherPermissionController>(
      () => TeacherPermissionController(),
    );
  }
}