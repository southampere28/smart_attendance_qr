import 'dart:developer';

import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_teacher/shedule/schedule_teacher/presentation/schedule_teacher_controller.dart';
import 'package:absensi_qr/feature_teacher/shedule/schedule_teacher/presentation/widgets/card_schedule_weekly_teacher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleTeacherPage extends StatelessWidget {
  const ScheduleTeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleTeacherController>();
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.backgroundColor,
          elevation: 0,
          centerTitle: false,
          title: Text(
            'Jadwal Anda',
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
              // todo here...
              log('refreshing schedule ...');
            },
            child: SingleChildScrollView(
                child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // todo here...
                  SpacingSize.spacingBaseHeight,
                  CardScheduleWeeklyTeacher(
                    day: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'],
                    dateDay: controller.dateOfWeek,
                    controller: controller,
                  )
                ],
              ),
            )),
          ),
        ));
  }
}
