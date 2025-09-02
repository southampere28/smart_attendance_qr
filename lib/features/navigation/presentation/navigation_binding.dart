import 'package:absensi_qr/features/attendance/presentation/attendance_controller.dart';
import 'package:absensi_qr/features/dashboard/presentation/dashboard_controller.dart';
import 'package:absensi_qr/features/navigation/presentation/navigation_controller.dart';
import 'package:absensi_qr/features/permission/presentation/permission_controller.dart';
import 'package:absensi_qr/features/profile/presentation/profile_controller.dart';
import 'package:get/get.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<AttendanceController>(() => AttendanceController(), fenix: true);
    Get.lazyPut<PermissionController>(() => PermissionController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
