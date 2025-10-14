import 'package:absensi_qr/feature_teacher/dashboard/presentation/teacher_dashboard_controller.dart';
import 'package:get/get.dart';

class TeacherDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherDashboardController());
  }
}
