import 'dart:developer';

import 'package:absensi_qr/feature_teacher/attendance_student/primary/presentation/attendance_student_class_page.dart';
import 'package:absensi_qr/feature_teacher/dashboard/presentation/teacher_dashboard_page.dart';
import 'package:absensi_qr/feature_teacher/permission/presentation/teacher_permission_page.dart';
import 'package:absensi_qr/feature_teacher/profile/presentation/profile_teacher_page.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:app_settings/app_settings.dart';
import 'package:get/get.dart';

class NavigationTeacherController extends GetxController {
  final GeolocationService _geolocationService = Get.find<GeolocationService>();

  var currentIndex = 0.obs;

  final pages = [
    TeacherDashboardPage(),
    TeacherPermissionPage(),
    AttendanceStudentClassPage(),
    ProfileTeacherPage(),
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
