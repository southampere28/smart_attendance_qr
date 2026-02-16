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

  /// dummy only, replace next time.
  final dummySchedule = <Schedule>[
    //   // ================= SENIN =================
    //   Schedule(
    //     id: BigInt.from(1),
    //     idClass: BigInt.from(1),
    //     idTeacher: BigInt.from(1),
    //     teacherName: "Wahid Supriyadi",
    //     idSubject: BigInt.from(1),
    //     // subject: Subject(
    //     //   type: SubjectType.general,
    //     //   id: BigInt.from(1),
    //     //   name: "Matematika",
    //     // ),
    //     dayOfWeek: "senin",
    //     periodStart: 1,
    //     periodEnd: 2,
    //     periodStartString: "08:00",
    //     periodEndString: "09:00",
    //     startTime: DateTime.parse("1970-01-01 08:00:00"),
    //     endTime: DateTime.parse("1970-01-01 09:00:00"),
    //     code: "MAT-01",
    //   ),
    //   Schedule(
    //     id: BigInt.from(2),
    //     idClass: BigInt.from(1),
    //     idTeacher: BigInt.from(1),
    //     teacherName: "Wahid Supriyadi",
    //     idSubject: BigInt.from(2),
    //     // subject: Subject(
    //     //   id: BigInt.from(2),
    //     //   name: "Fisika",
    //     // ),
    //     dayOfWeek: "senin",
    //     periodStart: 3,
    //     periodEnd: 4,
    //     periodStartString: "09:00",
    //     periodEndString: "10:00",
    //     startTime: DateTime.parse("1970-01-01 09:00:00"),
    //     endTime: DateTime.parse("1970-01-01 10:00:00"),
    //     code: "FIS-01",
    //   ),

    //   // ================= SELASA =================
    //   Schedule(
    //     id: BigInt.from(3),
    //     idClass: BigInt.from(1),
    //     idTeacher: BigInt.from(1),
    //     teacherName: "Wahid Supriyadi",
    //     idSubject: BigInt.from(3),
    //     // subjectName: "Kimia",
    //     dayOfWeek: "selasa",
    //     periodStart: 1,
    //     periodEnd: 2,
    //     periodStartString: "08:00",
    //     periodEndString: "09:00",
    //     startTime: DateTime.parse("1970-01-01 08:00:00"),
    //     endTime: DateTime.parse("1970-01-01 09:00:00"),
    //     code: "KIM-01",
    //   ),
    //   Schedule(
    //     id: BigInt.from(4),
    //     idClass: BigInt.from(1),
    //     idTeacher: BigInt.from(1),
    //     teacherName: "Wahid Supriyadi",
    //     idSubject: BigInt.from(4),
    //     subjectName: "Bahasa Indonesia",
    //     dayOfWeek: "selasa",
    //     periodStart: 3,
    //     periodEnd: 4,
    //     periodStartString: "09:00",
    //     periodEndString: "10:00",
    //     startTime: DateTime.parse("1970-01-01 09:00:00"),
    //     endTime: DateTime.parse("1970-01-01 10:00:00"),
    //     code: "BIN-01",
    //   ),

    //   // ================= RABU =================
    //   Schedule(
    //     id: BigInt.from(5),
    //     idClass: BigInt.from(1),
    //     idTeacher: BigInt.from(1),
    //     teacherName: "Wahid Supriyadi",
    //     idSubject: BigInt.from(5),
    //     subjectName: "Bahasa Inggris",
    //     dayOfWeek: "rabu",
    //     periodStart: 1,
    //     periodEnd: 2,
    //     periodStartString: "08:00",
    //     periodEndString: "09:00",
    //     startTime: DateTime.parse("1970-01-01 08:00:00"),
    //     endTime: DateTime.parse("1970-01-01 09:00:00"),
    //     code: "BING-01",
    //   ),
    //   Schedule(
    //     id: BigInt.from(6),
    //     idClass: BigInt.from(1),
    //     idTeacher: BigInt.from(1),
    //     teacherName: "Wahid Supriyadi",
    //     idSubject: BigInt.from(6),
    //     subjectName: "Olahraga",
    //     dayOfWeek: "rabu",
    //     periodStart: 3,
    //     periodEnd: 4,
    //     periodStartString: "09:00",
    //     periodEndString: "10:00",
    //     startTime: DateTime.parse("1970-01-01 09:00:00"),
    //     endTime: DateTime.parse("1970-01-01 10:00:00"),
    //     code: "OR-01",
    //   ),

    //   // ================= KAMIS =================
    //   Schedule(
    //     id: BigInt.from(7),
    //     idClass: BigInt.from(1),
    //     idTeacher: BigInt.from(1),
    //     teacherName: "Wahid Supriyadi",
    //     idSubject: BigInt.from(1),
    //     subjectName: "Matematika",
    //     dayOfWeek: "kamis",
    //     periodStart: 1,
    //     periodEnd: 2,
    //     periodStartString: "08:00",
    //     periodEndString: "09:00",
    //     startTime: DateTime.parse("1970-01-01 08:00:00"),
    //     endTime: DateTime.parse("1970-01-01 09:00:00"),
    //     code: "MAT-02",
    //   ),
    //   Schedule(
    //     id: BigInt.from(8),
    //     idClass: BigInt.from(1),
    //     idTeacher: BigInt.from(1),
    //     teacherName: "Wahid Supriyadi",
    //     idSubject: BigInt.from(2),
    //     subjectName: "Fisika",
    //     dayOfWeek: "kamis",
    //     periodStart: 3,
    //     periodEnd: 4,
    //     periodStartString: "09:00",
    //     periodEndString: "10:00",
    //     startTime: DateTime.parse("1970-01-01 09:00:00"),
    //     endTime: DateTime.parse("1970-01-01 10:00:00"),
    //     code: "FIS-02",
    //   ),

    //   // ================= JUMAT =================
    //   Schedule(
    //     id: BigInt.from(9),
    //     idClass: BigInt.from(1),
    //     idTeacher: BigInt.from(1),
    //     teacherName: "Wahid Supriyadi",
    //     idSubject: BigInt.from(4),
    //     subjectName: "Bahasa Indonesia",
    //     dayOfWeek: "jumat",
    //     periodStart: 1,
    //     periodEnd: 2,
    //     periodStartString: "08:00",
    //     periodEndString: "09:00",
    //     startTime: DateTime.parse("1970-01-01 08:00:00"),
    //     endTime: DateTime.parse("1970-01-01 09:00:00"),
    //     code: "BIN-02",
    //   ),
    //   Schedule(
    //     id: BigInt.from(10),
    //     idClass: BigInt.from(1),
    //     idTeacher: BigInt.from(1),
    //     teacherName: "Wahid Supriyadi",
    //     idSubject: BigInt.from(5),
    //     subjectName: "Bahasa Inggris",
    //     dayOfWeek: "jumat",
    //     periodStart: 3,
    //     periodEnd: 4,
    //     periodStartString: "09:00",
    //     periodEndString: "10:00",
    //     startTime: DateTime.parse("1970-01-01 09:00:00"),
    //     endTime: DateTime.parse("1970-01-01 10:00:00"),
    //     code: "BING-02",
    //   ),

    //   // ================= SABTU =================
    //   Schedule(
    //     id: BigInt.from(11),
    //     idClass: BigInt.from(1),
    //     idTeacher: BigInt.from(1),
    //     teacherName: "Wahid Supriyadi",
    //     idSubject: BigInt.from(6),
    //     subjectName: "Olahraga",
    //     dayOfWeek: "sabtu",
    //     periodStart: 1,
    //     periodEnd: 2,
    //     periodStartString: "07:00",
    //     periodEndString: "08:00",
    //     startTime: DateTime.parse("1970-01-01 07:00:00"),
    //     endTime: DateTime.parse("1970-01-01 08:00:00"),
    //     code: "OR-02",
    //   ),
    //   Schedule(
    //     id: BigInt.from(12),
    //     idClass: BigInt.from(1),
    //     idTeacher: BigInt.from(1),
    //     teacherName: "Wahid Supriyadi",
    //     idSubject: BigInt.from(1),
    //     subjectName: "Matematika",
    //     dayOfWeek: "sabtu",
    //     periodStart: 3,
    //     periodEnd: 4,
    //     periodStartString: "08:00",
    //     periodEndString: "09:00",
    //     startTime: DateTime.parse("1970-01-01 08:00:00"),
    //     endTime: DateTime.parse("1970-01-01 09:00:00"),
    //     code: "MAT-03",
    //   ),
  ].obs;

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
    final List<Schedule> filtered = dataSchedule
        .where((schedule) => schedule.dayOfWeek == dayKey)
        .toList();
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
