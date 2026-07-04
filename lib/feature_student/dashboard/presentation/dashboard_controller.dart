import 'dart:developer';

import 'package:absensi_qr/configs/api_constant.dart';
import 'package:absensi_qr/feature_student/navigation/presentation/navigation_controller.dart';
import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/models/academic_period_model.dart';
import 'package:absensi_qr/models/attendance_daily.dart';
import 'package:absensi_qr/models/attendance_history.dart';
import 'package:absensi_qr/models/model_merging/attendance_report_item.dart';
import 'package:absensi_qr/models/model_merging/schedule_attendance_report.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:app_settings/app_settings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final EndpointService _httpService = Get.find<EndpointService>();
  final NavigationController navigationController =
      Get.find<NavigationController>();

  final GeolocationService _geolocationService = Get.find<GeolocationService>();
  final MainController mainController = Get.find<MainController>();

  var isConnected = false.obs;

  // is weekend check
  bool get isWeekend {
    final int weekday = dateNow.weekday;
    // return weekday == DateTime.sunday;
    return false;
  }

  DateTime dateNow = DateTime(2026, 6, 25, 8, 0, 0);

  // final DateTime dateDummyOnly = DateTime(2026, 2, 16, 8, 0, 0);

  String get dateNowFormatted => AppUtil.formatDateIndonesia(dateNow);

  /// data zone
  // profile student
  final RxString name = ''.obs;
  final RxString firstName = ''.obs;
  final RxString nisn = ''.obs;
  final RxString email = ''.obs;
  final RxString className = ''.obs;
  final RxString major = ''.obs;
  final RxString entryYear = ''.obs;
  final RxString profileImageURL = ''.obs;

  // attendance history
  RxBool isLoadingAttendanceHistory = true.obs;
  RxList<AttendanceReportItem> attendanceHistoryResult =
      <AttendanceReportItem>[].obs;

  // upcoming or ongoing attendance
  RxBool isLoadingUpcomingOrOngoingAttendance = true.obs;
  AttendanceReportItem? upcomingOrOngoingAttendanceResult;

  RxBool isLoadingAttendanceByClassHistory = true.obs;
  RxList<ScheduleAttendanceReport> attendanceByClassHistoryResult =
      <ScheduleAttendanceReport>[].obs;

  RxBool isLoadingAttendanceDaily = true.obs;
  Rx<AttendanceDaily?> attendanceDailyResult = Rx<AttendanceDaily?>(null);

  /// data zone END

  Future<void> checkConnection() async {
    isConnected.value = await _httpService.testConnection();
  }

  // geolocation
  Future<void> getLocation() async {
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

  // guard check student data
  bool get hasStudentData => _httpService.studentData != null;

  String get placemark => _geolocationService.outputPlacemark.value;

  // kota
  String get placemarkCity =>
      _geolocationService.placemarkResult.value?.subAdministrativeArea ??
      '(No Data)';

  // jalan
  String get placemarkStreet =>
      _geolocationService.placemarkResult.value?.street ?? '(No Data)';

  // kecamatan
  String get placemarkLocality =>
      _geolocationService.placemarkResult.value?.locality ?? '';

  // desa
  String get placemarkVillage =>
      _geolocationService.placemarkResult.value?.subLocality ?? '';

  @override
  void onInit() {
    super.onInit();
    if (!hasStudentData) {
      Fluttertoast.showToast(msg: 'msg_missing_student_data');
    } else {
      /// data student is available
      _setProfileData();
      // Load data asynchronously without blocking controller initialization
      _loadDashboardData();

      // check active academic period if not loaded yet, just fetch it once
      if (mainController.activeAcademicPeriod.value == null) {
        _loadActiveAcademicPeriod();
      }
    }

    ever(mainController.refreshHomeStudent, (_) {
      _loadDashboardData();
    });

    ever(mainController.triggerUpdateProfile, (_) {
      _setProfileData();
    });
  }

  void _loadDashboardData() async {
    try {
      await Future.wait([
        getHistoryAttendance(),
        getAttendanceHistoryDaily(),
        getHistoryAttendanceByClass(),
      ]);
      await getUpcomingOrOngoingAttendance();
    } catch (e) {
      log('Error loading dashboard data: $e');
    }
  }

  // service zone
  Future<void> _loadActiveAcademicPeriod() async {
    try {
      final activePeriod = await _httpService.getActiveAcademicPeriod(timeout: const Duration(seconds: 5));

      if (activePeriod.success && activePeriod.data != null) {
        mainController.activeAcademicPeriod.value =
            AcademicPeriodModel.fromJson(activePeriod.data!);
        
        log('Active academic period: ${mainController.activeAcademicPeriod.value}');

      } else {
        mainController.activeAcademicPeriod.value = null;
      }
    } catch (e) {
      // log error tapi tetap lanjut ke halaman berikutnya
      Fluttertoast.showToast(msg: 'Gagal memuat periode aktif, coba lagi nanti');
    }
  }

  _setProfileData() {
    final String? emailService = _httpService.userData != null
        ? (_httpService.userData!['email'] as String?)
        : null;

    name.value = _httpService.studentData?.name ?? '';
    firstName.value = _httpService.studentData?.name?.split(' ').first ?? '';
    nisn.value = _httpService.studentData?.nisn ?? '';
    email.value = emailService ?? '';
    className.value = _httpService.studentData?.classData?.name ?? '';
    major.value = _httpService.studentData?.classData?.major ?? '';
    entryYear.value = _httpService.studentData != null
        ? _httpService.studentData!.entryYear.toString()
        : '';

    final String? profilePicture = _httpService.userModel?.profilePicture;
    if (profilePicture != null) {
      profileImageURL.value =
          ApiConstant.getProfilePictureURL(profilePicture, 'student');
    }
  }

  // get attendance history by now
  Future<void> getHistoryAttendance() async {
    isLoadingAttendanceHistory.value = true;
    // guard: ensure student data and class id available
    final BigInt? idClass = _httpService.studentData?.idClass;

    if (idClass == null) {
      Fluttertoast.showToast(msg: 'missing_class_id');
      isLoadingAttendanceHistory.value = false;
      return;
    }

    // attendanceBySchedule expects strings: idClass and date (YYYY-MM-DD)
    final String idClassStr = idClass.toString();
    final String dateStr = '${dateNow.year.toString().padLeft(4, '0')}-'
        '${dateNow.month.toString().padLeft(2, '0')}-'
        '${dateNow.day.toString().padLeft(2, '0')}';

    final result = await _httpService.attendanceBySchedule(
      idClass: idClassStr,
      date: dateStr,
    );
    if (result.success) {
      final List<dynamic>? raw = result.data;
      if (raw != null) {
        final items = raw
            .map((e) => AttendanceReportItem.fromMap(e as Map<String, dynamic>))
            .toList();
        attendanceHistoryResult.assignAll(items);
        log('Loaded ${items.length} attendance items');
      } else {
        attendanceHistoryResult.clear();
      }
    } else {
      Fluttertoast.showToast(
          msg: result.message ?? 'msg_failed_fetch_attendance');
    }
    isLoadingAttendanceHistory.value = false;
  }

  // get upcoming or ongoing attendance based on history attendance
  Future<void> getUpcomingOrOngoingAttendance() async {
    isLoadingUpcomingOrOngoingAttendance.value = true;

    log('data attendance history count: ${attendanceHistoryResult.length}');

    /// load data index 0
    log('data attendance history index 0: ${attendanceHistoryResult.isNotEmpty ? attendanceHistoryResult[0].schedule.toString() : 'No Data'}');

    /// dummy date for testing

    try {
      if (attendanceHistoryResult.isNotEmpty) {
        // Step 1: Try to find ONGOING attendance
        final ongoing = attendanceHistoryResult.firstWhereOrNull((item) {
          final timeStart = item.schedule.startTime;
          final timeEnd = item.schedule.endTime;

          final todayStartTime = DateTime(
            dateNow.year,
            dateNow.month,
            dateNow.day,
            timeStart.hour,
            timeStart.minute,
            timeStart.second,
          );

          final todayEndTime = DateTime(
            dateNow.year,
            dateNow.month,
            dateNow.day,
            timeEnd.hour,
            timeEnd.minute,
            timeEnd.second,
          );

          if (timeStart != null && timeEnd != null) {
            return dateNow.isAfter(todayStartTime) &&
                dateNow.isBefore(todayEndTime);
          }
          return false;
        });

        if (ongoing != null) {
          upcomingOrOngoingAttendanceResult = ongoing;
        } else {
          // Step 2: No ongoing, find UPCOMING (nearest/terdekat)
          final upcomingList = <AttendanceReportItem>[];

          for (final item in attendanceHistoryResult) {
            final timeStart = item.schedule.startTime;

            if (timeStart == null) continue;

            final todayStartTime = DateTime(
              dateNow.year,
              dateNow.month,
              dateNow.day,
              timeStart.hour,
              timeStart.minute,
              timeStart.second,
            );

            // Collect all upcoming items
            if (dateNow.isBefore(todayStartTime)) {
              upcomingList.add(item);
            }
          }

          if (upcomingList.isNotEmpty) {
            // Sort by startTime ascending to get the nearest upcoming
            upcomingList.sort(
              (a, b) => a.schedule.startTime.compareTo(b.schedule.startTime),
            );
            upcomingOrOngoingAttendanceResult = upcomingList.first;
            log('Found nearest upcoming attendance at ${upcomingList.first.schedule.startTime}');
          } else {
            upcomingOrOngoingAttendanceResult = null;
            log('No upcoming or ongoing attendance found');
          }
        }
      } else {
        upcomingOrOngoingAttendanceResult = null;
        log('Attendance history is empty');
      }
    } catch (e) {
      upcomingOrOngoingAttendanceResult = null;
      log('Error getting upcoming attendance: $e');
    }
    isLoadingUpcomingOrOngoingAttendance.value = false;
  }

  // get attendance daily by class history.
  Future<void> getAttendanceHistoryDaily() async {
    isLoadingAttendanceDaily.value = true;

    final String dateStr = '${dateNow.year.toString().padLeft(4, '0')}-'
        '${dateNow.month.toString().padLeft(2, '0')}-'
        '${dateNow.day.toString().padLeft(2, '0')}';

    final result = await _httpService.attendanceReportDaily(dateNow);
    log('attendanceReportDaily result success: ${result.success} status: ${result.statusCode}');

    if (result.success) {
      final Map<String, dynamic>? raw = result.data;
      if (raw != null) {
        final attendanceDaily = AttendanceDaily.fromMap(raw);
        attendanceDailyResult.value = attendanceDaily;
        log('Loaded attendance daily report for date ${dateStr}');
      } else {
        attendanceDailyResult.value = null;
      }
    } else {
      Fluttertoast.showToast(
          msg: result.message ?? 'msg_failed_fetch_attendance');
    }
    isLoadingAttendanceDaily.value = false;
  }

  // get attendance by class history
  Future<void> getHistoryAttendanceByClass() async {
    isLoadingAttendanceByClassHistory.value = true;

    // guard: ensure student data and class id available
    final BigInt? idClass = _httpService.studentData?.idClass;

    if (idClass == null) {
      Fluttertoast.showToast(msg: 'missing_class_id');
      isLoadingAttendanceByClassHistory.value = false;
      return;
    }

    // attendanceBySchedule expects strings: idClass and date (YYYY-MM-DD)
    final String idClassStr = idClass.toString();
    final String dateStr = '${dateNow.year.toString().padLeft(4, '0')}-'
        '${dateNow.month.toString().padLeft(2, '0')}-'
        '${dateNow.day.toString().padLeft(2, '0')}';

    final result = await _httpService.attendanceReportByScheduleClass(
        idClass: idClassStr, date: dateStr);

    if (result.success) {
      final List<dynamic>? raw = result.data;
      if (raw != null) {
        final items = raw
            .map((e) =>
                ScheduleAttendanceReport.fromMap(e as Map<String, dynamic>))
            .toList();
        attendanceByClassHistoryResult.assignAll(items);
        log('Loaded ${items.length} schedule attendance items');
      } else {
        attendanceByClassHistoryResult.clear();
      }
    } else {
      Fluttertoast.showToast(
          msg: result.message ?? 'msg_failed_fetch_attendance_by_class');
    }
    isLoadingAttendanceByClassHistory.value = false;
  }
}
