import 'package:absensi_qr/features/attendance/presentation/attendance_page.dart';
import 'package:absensi_qr/features/dashboard/presentation/dashboard_page.dart';
import 'package:absensi_qr/features/others/splash_screen/presentation/splash_screen_page.dart';
import 'package:absensi_qr/features/permission/presentation/permission_page.dart';
import 'package:absensi_qr/features/profile/presentation/profile_page.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;

  final pages = [
    DashboardPage(),
    AttendancePage(),
    PermissionPage(),
    ProfilePage(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
