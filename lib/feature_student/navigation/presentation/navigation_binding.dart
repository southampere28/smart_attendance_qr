import 'package:absensi_qr/feature_student/attendance/presentation/attendance_controller.dart';
import 'package:absensi_qr/feature_student/dashboard/presentation/dashboard_controller.dart';
import 'package:absensi_qr/feature_student/navigation/presentation/navigation_controller.dart';
import 'package:absensi_qr/feature_student/permission/presentation/permission_controller.dart';
import 'package:absensi_qr/feature_student/profile/presentation/profile_controller.dart';
import 'package:get/get.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<AttendanceController>(() => AttendanceController());
    Get.lazyPut<PermissionController>(() => PermissionController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<NavigationController>(() => NavigationController());
  }
}
