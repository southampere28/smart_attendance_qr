import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
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
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
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
                dateDay: ['12', '13', '14', '15', '16', '17'],
                controller: controller,
              ),
              SpacingSize.spacingBaseHeight,
              Obx(() {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(
                      controller.filteredSchedule.length,
                      (index) {
                        final schedule = controller.filteredSchedule[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: CardSubjectWeekly(
                            subjectName:
                                schedule.subjectName ?? '(Tidak Diketahui)',
                            teacherName:
                                schedule.teacherName ?? '(Tidak Diketahui)',
                            scheduleInfo:
                                '${schedule.periodStartString}-${schedule.periodEndString} WIB',
                          ),
                        );
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      )),
    );
  }
}
