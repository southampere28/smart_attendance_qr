import 'package:absensi_qr/feature_teacher/attendance_student/primary/presentation/attendance_student_class_controller.dart';
import 'package:get/get.dart';

class AttendanceStudentClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceStudentClassController>(
      () => AttendanceStudentClassController(),
    );
  }
}