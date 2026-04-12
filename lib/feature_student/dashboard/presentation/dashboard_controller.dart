import 'dart:developer';

import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/models/attendance_daily.dart';
import 'package:absensi_qr/models/attendance_history.dart';
import 'package:absensi_qr/models/model_merging/attendance_report_item.dart';
import 'package:absensi_qr/models/model_merging/schedule_attendance_report.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final EndpointService _httpService = Get.find<EndpointService>();

  final GeolocationService _geolocationService = Get.find<GeolocationService>();

  var isConnected = false.obs;

  // is weekend check
  bool get isWeekend {
    final int weekday = dateNow.weekday;
    return weekday == DateTime.sunday;
  }

  final DateTime dateNow = DateTime.now();

  final DateTime dateDummyOnly = DateTime(2026, 2, 16);

  String get dateNowFormatted => AppUtil.formatDateIndonesia(dateNow);

  /// data zone

  // attendance history
  RxBool isLoadingAttendanceHistory = true.obs;
  RxList<AttendanceReportItem> attendanceHistoryResult =
      <AttendanceReportItem>[].obs;

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
    await _geolocationService.getCurrentPosition(30);
    // await getPlacemarkLocation();
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
    // TODO: implement onInit
    super.onInit();
    if (!hasStudentData) {
      Fluttertoast.showToast(msg: 'msg_missing_student_data');
    } else {
      /// data student is available
      getHistoryAttendance();
      getAttendanceHistoryDaily();
    }
  }

  // service zone
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

  // get attendance daily by class history.
  Future<void> getAttendanceHistoryDaily() async {
    isLoadingAttendanceDaily.value = true;

    final String dateStr = '${dateDummyOnly.year.toString().padLeft(4, '0')}-'
        '${dateDummyOnly.month.toString().padLeft(2, '0')}-'
        '${dateDummyOnly.day.toString().padLeft(2, '0')}';

    final result = await _httpService.attendanceReportDaily(dateDummyOnly);
    log('attendanceReportDaily result success: ${result.success} status: ${result.statusCode}');

    if (result.success) {
      final Map<String, dynamic>? raw = result.data;
      if (raw != null) {
        final attendanceDaily = AttendanceDaily.fromMap(raw);
        attendanceDailyResult.value = attendanceDaily;
        log('Loaded attendance daily report for date ${dateStr}');
        Fluttertoast.showToast(
            msg: 'Data: ${attendanceDailyResult.value?.status ?? 'No status'}');
      } else {
        attendanceDailyResult.value = null;
        Fluttertoast.showToast(msg: 'Data: No Data Found on This Date');
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
