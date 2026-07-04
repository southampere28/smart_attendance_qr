import 'package:absensi_qr/features/others/auth/register_student/presentation/register_student_controller.dart';
import 'package:get/get.dart';

class RegisterStudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterStudentController>(() => RegisterStudentController());
  }
}
