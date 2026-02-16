import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/helper/schedule_helper.dart';
import 'package:absensi_qr/core/widgets/shimmer_load_card.dart';
import 'package:absensi_qr/feature_student/schedule/presentation/schedule_controller.dart';
import 'package:absensi_qr/feature_student/schedule/presentation/widgets/card_pickdate_weekly.dart';
import 'package:absensi_qr/feature_student/schedule/presentation/widgets/card_subject_weekly.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleController>();

    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.backgroundColor,
          elevation: 0,
          centerTitle: false,
          title: Text(
            'Jadwal',
            style: AppFontStyle.titleText.copyWith(color: Colors.black),
          ),
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.black, size: 30),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              controller.getAllSchedule();
            },
            child: SingleChildScrollView(
              controller: ScrollController(),
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpacingSize.spacingBaseHeight,
                    CardPickdateWeekly(
                      day: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'],
                      dateDay: controller.dateOfWeek,
                      controller: controller,
                    ),
                    SpacingSize.spacingBaseHeight,
                    Obx(() {
                      if (controller.isLoading.value) {
                        return ShimmerLoadCard(
                          shimmerItemCount: 3,
                        );
                      }

                      if (controller.filteredSchedule.isEmpty) {
                        return Column(
                          children: [
                            SpacingSize.spacingLGHeight,
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 4),
                              child: Text('Jadwal Tidak Ditemukan',
                                  style: AppFontStyle.subTitleText),
                            ),
                          ],
                        );
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: controller.filteredSchedule.map(
                          (item) {
                            final schedule = item;

                            final startTime = ScheduleHelper.convertTime2Pad(
                                schedule.startTime);
                            final endTime = ScheduleHelper.convertTime2Pad(
                                schedule.endTime);

                            return Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: CardSubjectWeekly(
                                subjectName: schedule.subject?.name ??
                                    '(Tidak Diketahui)',
                                teacherName: schedule.teacher?.name ??
                                    '(Tidak Diketahui)',
                                scheduleInfo: '$startTime - $endTime WIB',
                              ),
                            );
                          },
                        ).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
