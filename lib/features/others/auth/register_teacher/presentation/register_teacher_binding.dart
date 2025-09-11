import 'package:absensi_qr/features/others/auth/register_teacher/presentation/register_teacher_controller.dart';
import 'package:get/get.dart';

class RegisterTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterTeacherController>(() => RegisterTeacherController());
  }
}
