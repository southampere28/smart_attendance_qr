import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/widgets/card_attendance_daily_status.dart';
import 'package:absensi_qr/core/widgets/shimmer_load_card.dart';
import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:absensi_qr/feature_student/attendance/presentation/attendance_controller.dart';
import 'package:absensi_qr/feature_student/attendance/presentation/widgets/card_attendance_date_schedule.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    AttendanceController controller = Get.find<AttendanceController>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshData();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Riwayat Absensi',
                    style: AppFontStyle.titleText.copyWith(fontSize: 18)),
                Obx(() => Text(
                    'Semester ${controller.activeAcademicPeriod.value?.name ?? ''}',
                    style: AppFontStyle.subTitleText)),
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
                  child: Builder(
                    builder: (context) {
                      final activePeriod = controller
                          .mainController.activeAcademicPeriod.value;
                      final DateTime firstDate =
                          activePeriod?.startDate ?? DateTime(2025);
                      final DateTime lastDate =
                          activePeriod?.endDate ?? DateTime(2030);
                      DateTime initialDate = controller.selectedDate.value;
                      if (initialDate.isBefore(firstDate)) {
                        initialDate = firstDate;
                      }
                      if (initialDate.isAfter(lastDate)) {
                        initialDate = lastDate;
                      }
                      return CalendarDatePicker(
                        initialDate: initialDate,
                        firstDate: firstDate,
                        lastDate: lastDate,
                        onDateChanged: (DateTime date) {
                          controller.selectedDate.value = date;
                          controller.getHistoryAttendance();
                          controller.getAttendanceHistoryDaily();
                        },
                      );
                    },
                  ),
                ),
                SpacingSize.spacingBaseHeight,
                // this will shown as widget card with 2 separated sections: today and history.
                Container(
                  constraints: const BoxConstraints(minHeight: 200),
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
                          height: 300,
                          child: TabBarView(
                            children: [
                              /// data history attendance daily face recognition.
                              SingleChildScrollView(
                                child: Obx(() => Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            controller.isLoadingAttendanceDaily
                                                    .value
                                                ? ShimmerLoadCard(
                                                    shimmerItemCount: 1,
                                                    customHeight: 60,
                                                  )
                                                : CardAttendanceDailyStatus(
                                                    attendance: controller
                                                        .attendanceDailyResult
                                                        .value),
                                            SpacingSize.spacingBaseHeight,
                                          ]),
                                    )),
                              ),

                              /// data history attendance by subject with schedule info.
                              SingleChildScrollView(
                                child: Obx(() => Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            controller
                                                    .isLoadingAttendanceHistory
                                                    .value
                                                ? ShimmerLoadCard(
                                                    shimmerItemCount: 3,
                                                    customHeight: 60,
                                                  )
                                                : Column(
                                                    children: [
                                                      ...controller
                                                          .attendanceHistoryResult
                                                          .map((item) {
                                                        return CardAttendanceDateSchedule(
                                                            subjectName: item
                                                                    .schedule
                                                                    .subject
                                                                    ?.name ??
                                                                '(Mata Pelajaran)',
                                                            badgeInfo: item
                                                                        .attendance
                                                                        ?.status !=
                                                                    null
                                                                ? item
                                                                    .attendance!
                                                                    .status
                                                                : AttendanceStatusEnum
                                                                    .alpha,
                                                            attendanceDateTime:
                                                                item.attendance
                                                                    ?.createdAt);
                                                      }).toList(),
                                                    ],
                                                  )
                                          ]),
                                    )),
                              ),
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
      ),
    );
  }
}
