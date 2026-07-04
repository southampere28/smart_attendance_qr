import 'package:absensi_qr/feature_teacher/profile/presentation/profile_teacher_controller.dart';
import 'package:get/get.dart';

class ProfileTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileTeacherController>(
      () => ProfileTeacherController(),
    );
  }

}