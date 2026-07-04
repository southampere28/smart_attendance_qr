import 'dart:developer';

import 'package:absensi_qr/feature_student/attendance/presentation/attendance_page.dart';
import 'package:absensi_qr/feature_student/dashboard/presentation/dashboard_page.dart';
import 'package:absensi_qr/feature_student/permission/presentation/permission_page.dart';
import 'package:absensi_qr/feature_student/profile/presentation/profile_page.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:app_settings/app_settings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final GeolocationService _geolocationService = Get.find<GeolocationService>();

  // is mockup flag
  var isUserUsingMockLocation = false.obs;

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
    super.onInit();
    // Don't await GPS check in onInit - handle asynchronously instead
    await checkMockLocation();
    if (isUserUsingMockLocation.value) {
      // If user is using mock location, show warning and don't check GPS
      return;
    }
    _checkGpsStatus();
  }

  void _checkGpsStatus() async {
    try {
      await _geolocationService.waitForGpsEnabled(maxRetries: 5);
    } catch (e) {
      log("Gagal menunggu GPS aktif: $e");
      if (Get.isSnackbarOpen == false) {
        Get.snackbar(
          'GPS Tidak Aktif',
          'Mohon nyalakan GPS untuk menggunakan aplikasi',
          duration: const Duration(seconds: 3),
        );
      }
      AppSettings.openAppSettings(type: AppSettingsType.location);
    }
  }

  // check if mock location is enabled, if yes show warning toast to user that they cannot use fake location for attendance.
  Future<void> checkMockLocation() async {
    var isMockLocation = await _geolocationService.isMockLocation();

    if (isMockLocation) {
      Fluttertoast.showToast(
          msg:
              'Terdeteksi penggunaan mock location, pastikan Anda tidak menggunakan aplikasi fake location untuk melakukan absensi.');
      isUserUsingMockLocation.value = true;
      _geolocationService.lattitude = '';
      _geolocationService.longitude = '';

      // reset placemark value
      _geolocationService.outputPlacemark.value = '';
      _geolocationService.placemarkResult.value = null;

    }
  }
}
