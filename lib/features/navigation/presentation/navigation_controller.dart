import 'dart:developer';

import 'package:absensi_qr/features/attendance/presentation/attendance_page.dart';
import 'package:absensi_qr/features/dashboard/presentation/dashboard_page.dart';
import 'package:absensi_qr/features/others/splash_screen/presentation/splash_screen_page.dart';
import 'package:absensi_qr/features/permission/presentation/permission_page.dart';
import 'package:absensi_qr/features/profile/presentation/profile_page.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:app_settings/app_settings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final GeolocationService _geolocationService = Get.find<GeolocationService>();

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

  bool getLocationStatus() {
    var statusLocationService = _geolocationService.serviceStatusValue;

    if (statusLocationService == "enabled") {
      return true;
    } else {
      return false;
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    try {
      await _geolocationService.waitForGpsEnabled(maxRetries: 5);
    } catch (e) {
      log("Gagal menunggu GPS aktif: $e");
      AppSettings.openAppSettings(type: AppSettingsType.location);
    }
  }
}
