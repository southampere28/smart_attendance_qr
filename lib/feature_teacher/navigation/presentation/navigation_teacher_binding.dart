import 'package:absensi_qr/feature_teacher/attendance_student/primary/presentation/attendance_student_class_controller.dart';
import 'package:absensi_qr/feature_teacher/dashboard/presentation/teacher_dashboard_controller.dart';
import 'package:absensi_qr/feature_teacher/permission/presentation/teacher_permission_controller.dart';
import 'package:absensi_qr/feature_teacher/profile/presentation/profile_teacher_controller.dart';
import 'package:absensi_qr/feature_teacher/teacher_activity/presentation/activity_teacher_controller.dart';
import 'package:get/get.dart';
import 'navigation_teacher_controller.dart';

class NavigationTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherDashboardController>(
      () => TeacherDashboardController(),
    );
    Get.lazyPut<ProfileTeacherController>(
      () => ProfileTeacherController(),
    );
    Get.lazyPut<TeacherPermissionController>(
      () => TeacherPermissionController(),
    );
    Get.lazyPut<ActivityTeacherController>(
      () => ActivityTeacherController(),
    );
    Get.lazyPut<AttendanceStudentClassController>(
      () => AttendanceStudentClassController(),
    );
    Get.lazyPut<NavigationTeacherController>(
      () => NavigationTeacherController(),
    );
  }
}
