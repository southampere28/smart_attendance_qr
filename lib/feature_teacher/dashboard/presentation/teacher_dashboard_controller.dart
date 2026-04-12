import 'dart:developer';
import 'package:absensi_qr/models/model_merging/schedule_report_item.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:get/get.dart';

class TeacherDashboardController extends GetxController {
  // service controller
  final EndpointService _httpService = Get.find<EndpointService>();

  final GeolocationService _geolocationService = Get.find<GeolocationService>();

  final RxBool isLoading = false.obs;
  final RxList<ScheduleReportItem> dataSchedule = <ScheduleReportItem>[].obs;

  /// data geolocation
  
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

  /// data geolocation END

  DateTime dateNow = DateTime.now();
  String get dateNowFormatted => AppUtil.formatDateIndonesia(dateNow);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchTodayScheduleTeacher();
  }

  // === SERVICE ZONE ===
  Future<void> fetchTodayScheduleTeacher() async {
    isLoading.value = true;

    final result = await _httpService.teacherSchedulePersonal();

    if (result.success) {
      final List<dynamic>? raw = result.data;
      if (raw != null) {
        final items = raw
            .map((e) => ScheduleReportItem.fromMap(e as Map<String, dynamic>))
            .toList();

        // sort by schedule.startTime
        items.sort((a, b) {
          return a.schedule.startTime.compareTo(b.schedule.startTime);
        });

        dataSchedule.assignAll(items);
        log('Loaded ${items.length} schedule items');
      } else {
        dataSchedule.clear();
      }
    } else {
      dataSchedule.clear();
    }
    isLoading.value = false;
  }
}
