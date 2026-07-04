import 'package:absensi_qr/core/helper/schedule_helper.dart';
import 'package:absensi_qr/models/schedule.dart';
import 'package:absensi_qr/models/subject.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  // todo here...
  final RxInt indexSelected = 0.obs;

  // calling endpoint service
  final EndpointService _endpointService = Get.find<EndpointService>();

  /// schedule configuration...
  final List<String> scheduleMapper = ScheduleHelper.dayMapper;

  final List<String> day3letter = ScheduleHelper.dayMapper
      .map((day) => day.substring(0, 3).capitalizeFirst!)
      .toList();

  List<String> dateOfWeek = ScheduleHelper.getDatesOfWeek(6);

  RxBool isLoading = false.obs;
  late BigInt idClass;
  final dataSchedule = <Schedule>[].obs;
  final filteredSchedule = <Schedule>[].obs;

  // get month year name
  String get monthYearOfWeek {
    return ScheduleHelper.getMonthName(
        DateTime.now().month, DateTime.now().year);
  }

  @override
  void onInit() {
    super.onInit();
    filterScheduleByDay(indexSelected.value);
    if (_endpointService.studentData != null) {
      idClass = _endpointService.studentData!.idClass;
      getAllSchedule();
    } else {
      print('data student is null');
      Fluttertoast.showToast(msg: 'Gagal mendapatkan data kelas');
    }
  }

  void filterScheduleByDay(int indexDay) {
    final String dayKey = scheduleMapper[indexDay];
    final List<Schedule> filtered =
        dataSchedule.where((schedule) => schedule.dayOfWeek == dayKey).toList();
    filteredSchedule.value = filtered;
  }

  Future<void> getAllSchedule() async {
    isLoading.value = true;

    final result =
        await _endpointService.getAllSchedule(idClass: idClass.toString());

    if (result.success) {
      final List<dynamic>? raw = result.data;
      if (raw != null) {
        final List<Schedule> schedules = raw
            .map((e) => Schedule.fromMap(e as Map<String, dynamic>))
            .toList();
        dataSchedule.value = schedules;
        filterScheduleByDay(indexSelected.value);
        Fluttertoast.showToast(msg: 'Jadwal berhasil diperbarui');
      } else {
        Fluttertoast.showToast(msg: 'Data jadwal kosong');
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Gagal mendapatkan jadwal: ${result.message}');
    }

    isLoading.value = false;
  }
}
