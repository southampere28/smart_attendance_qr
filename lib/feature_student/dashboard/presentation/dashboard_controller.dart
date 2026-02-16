import 'dart:developer';

import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/models/attendance_history.dart';
import 'package:absensi_qr/models/model_merging/attendance_report_item.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final EndpointService _httpService = Get.find<EndpointService>();

  final GeolocationService _geolocationService = Get.find<GeolocationService>();

  var isConnected = false.obs;

  final DateTime dateNow = DateTime.now();

  final DateTime dateDummyOnly = DateTime(2026, 2, 16);

  String get dateNowFormatted => AppUtil.formatDateIndonesia(dateNow);

  /// data zone
  
  // attendance history
  RxBool isLoadingAttendanceHistory = true.obs;
  RxList<AttendanceReportItem> attendanceHistoryResult = <AttendanceReportItem>[].obs;
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
      _geolocationService.placemarkResult.value?.locality ?? '(No Data)';

  // desa
  String get placemarkVillage =>
      _geolocationService.placemarkResult.value?.subLocality ?? '(No Data)';

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (!hasStudentData) {
      Fluttertoast.showToast(msg: 'msg_missing_student_data');
    } else {
      /// data student is available
      getHistoryAttendance();
    }
  }

  // service
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
    final String dateStr = '${dateDummyOnly.year.toString().padLeft(4, '0')}-'
        '${dateDummyOnly.month.toString().padLeft(2, '0')}-'
        '${dateDummyOnly.day.toString().padLeft(2, '0')}';

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
      Fluttertoast.showToast(msg: result.message ?? 'msg_failed_fetch_attendance');
    }
    isLoadingAttendanceHistory.value = false;
  }

}
