import 'dart:developer';

import 'package:absensi_qr/feature_student/attendance/presentation/attendance_page.dart';
import 'package:absensi_qr/feature_student/dashboard/presentation/dashboard_page.dart';
import 'package:absensi_qr/feature_student/permission/presentation/permission_page.dart';
import 'package:absensi_qr/feature_student/profile/presentation/profile_page.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:app_settings/app_settings.dart';
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
