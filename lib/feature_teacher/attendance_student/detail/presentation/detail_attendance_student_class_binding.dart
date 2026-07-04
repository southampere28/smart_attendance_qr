import 'package:absensi_qr/feature_teacher/attendance_student/detail/presentation/detail_attendance_student_class_controller.dart';
import 'package:get/get.dart';

class DetailAttendanceStudentClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailAttendanceStudentClassController>(
      () => DetailAttendanceStudentClassController(),
    );
  }

}