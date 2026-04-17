import 'dart:developer';

import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_teacher/attendance_student/primary/presentation/attendance_student_class_controller.dart';
import 'package:absensi_qr/features/widgets/dropdown_input_widget.dart';
import 'package:absensi_qr/models/model_merging/schedule_student_attendance_report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceStudentClassPage extends StatelessWidget {
  const AttendanceStudentClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AttendanceStudentClassController>();

    return RefreshIndicator(
      onRefresh: () async {
        if (controller.selectedClassId != BigInt.from(-1)) {
          await controller.fetchAttendanceHistory(context);
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Riwayat Absensi',
                style: AppFontStyle.titleText.copyWith(color: Colors.black),
              ),

              Obx(() => DropdownInputWidget(
                  title: 'Kelas',
                  selected: controller.selectedItem.value,
                  items: controller.classItemList.toList(),
                  onChanged: (value) {
                    // do something
                    controller.selectedItem.value = value ?? '(Pilih Kelas)';

                    if (value != null && value != '(Pilih Kelas)') {
                      final selectedId = controller.classMap[value];
                      log('Selected: $value, ID: $selectedId');
                      controller.selectedClassId = selectedId!;
                      controller.fetchAttendanceHistory(context);
                    } else {
                      controller.selectedClassId = BigInt.from(-1);
                    }
                  },
                  hint: '(Pilih Kelas)')),

              Text('Riwayat Absensi',
                  style: AppFontStyle.titleText.copyWith(fontSize: 18)),
              Text('Semester Ganjil 2023/2024',
                  style: AppFontStyle.subTitleText),
              SpacingSize.spacingBaseHeight,
              // this will shown as calendar widget.
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.colorShadowBox,
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CalendarDatePicker(
                  initialDate: controller.selectedDate.value,
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2030),
                  onDateChanged: (DateTime date) {
                    controller.selectedDate.value = date;
                    controller.fetchAttendanceHistory(context);
                    // controller.getAttendanceHistoryDaily();
                  },
                ),
              ),
              SpacingSize.spacingBaseHeight,
              // this will shown as widget card with 2 separated sections: today and history.
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.colorShadowBox,
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TabBar(
                          labelColor: AppColor.primaryColor,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: AppColor.primaryColor,
                          tabs: const [
                            Tab(text: 'Absensi Harian'),
                            Tab(text: 'Absensi Mapel'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          children: [
                            /// data history attendance daily face recognition.
                            Center(child: Text("Overview Content")),

                            /// data history attendance by subject with schedule info.
                            Obx(() => Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ...controller.attendanceHistoryResult
                                            .map((item) {
                                          return _cardTestScheduleAttendance(
                                              item);
                                        }).toList(),
                                        ElevatedButton(
                                            onPressed: () {
                                              controller
                                                  .fetchAttendanceHistory(context);
                                            },
                                            child: const Text("Refresh"))
                                      ]),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardTestScheduleAttendance(ScheduleStudentAttendanceReport item) {
    return Card(
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.detailAttendanceStudentClass,
              arguments: item.attendances);
        },
        child: ListTile(
          title: Text(item.schedule.subject?.name ?? '(Mata Pelajaran)'),
          subtitle: Text(item.schedule.createdAt.toString()),
          // trailing: Text(item.attendanceStatus?.toString() ?? 'No Status'),
        ),
      ),
    );
  }
}
