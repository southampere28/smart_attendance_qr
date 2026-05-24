import 'dart:developer';

import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/models/academic_period_model.dart';
import 'package:absensi_qr/models/attendance_daily.dart';
import 'package:absensi_qr/models/model_merging/attendance_report_item.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AttendanceController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final EndpointService _httpService = Get.find<EndpointService>();
  final MainController mainController = Get.find<MainController>();
  final RxBool isLoadingAttendanceHistory = true.obs;
  final RxBool isLoadingAttendanceDaily = true.obs;

  final selectedDate = DateTime.now().obs;

  RxList<AttendanceReportItem> attendanceHistoryResult =
      <AttendanceReportItem>[].obs;

  final Rx<AttendanceDaily?> attendanceDailyResult = Rx<AttendanceDaily?>(null);

  Rx<AcademicPeriodModel?> get activeAcademicPeriod => mainController.activeAcademicPeriod;

  @override
  void onInit() {
    super.onInit();
    getAttendanceHistoryDaily();
    getHistoryAttendance();
  }

  Future<void> getAttendanceHistoryDaily() async {
    isLoadingAttendanceDaily.value = true;

    final result = await _httpService.attendanceReportDaily(selectedDate.value);
    log('attendanceReportDaily result success: ${result.success} status: ${result.statusCode}');

    if (result.success) {
      final Map<String, dynamic>? raw = result.data;
      if (raw != null) {
        final attendanceDaily = AttendanceDaily.fromMap(raw);
        attendanceDailyResult.value = attendanceDaily;
        log('Loaded attendance daily report for date ${selectedDate.value.toIso8601String()}');
      } else {
        attendanceDailyResult.value = null;
      }
    } else {
      Fluttertoast.showToast(
          msg: result.message ?? 'msg_failed_fetch_attendance');
    }
    isLoadingAttendanceDaily.value = false;
  }

  Future<void> getHistoryAttendance() async {
    isLoadingAttendanceHistory.value = true;
    // guard: ensure student data and class id available
    final BigInt? idClass = _httpService.studentData?.idClass;

    if (idClass == null) {
      Fluttertoast.showToast(msg: 'missing_class_id');
      isLoadingAttendanceHistory.value = false;
      return;
    }

    // debug: log class id and token presence to help trace fetching issues
    log('getHistoryAttendance -> idClass: ${idClass.toString()}');
    log('getHistoryAttendance -> has accessToken: ${_httpService.accessToken != null}');

    // attendanceBySchedule expects strings: idClass and date (YYYY-MM-DD)
    final String idClassStr = idClass.toString();
    final String dateStr =
        '${selectedDate.value.year.toString().padLeft(4, '0')}-'
        '${selectedDate.value.month.toString().padLeft(2, '0')}-'
        '${selectedDate.value.day.toString().padLeft(2, '0')}';

    final result = await _httpService.attendanceBySchedule(
      idClass: idClassStr,
      date: dateStr,
    );
    if (Get.context != null) {
      AppUtil.hideLoadingDialog(Get.context!);
    }
    log('attendanceBySchedule result success: ${result.success} status: ${result.statusCode}');
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

  Future<void> refreshData() async {
    await getAttendanceHistoryDaily();
    await getHistoryAttendance();
  }
}
