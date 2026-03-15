import 'dart:developer';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_teacher/shedule/schedule_class/presentation/schedule_class_controller.dart';
import 'package:absensi_qr/feature_teacher/shedule/schedule_class/presentation/widgets/card_schedule_weekly_class_teacher.dart';
import 'package:absensi_qr/features/widgets/dropdown_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ScheduleClassPage extends StatelessWidget {
  const ScheduleClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleClassController>();
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.backgroundColor,
          elevation: 0,
          centerTitle: false,
          title: Text(
            'Jadwal Kelas',
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
              controller.fetchScheduleWeeklyTeacherByClass(
                  controller.selectedClassId.toString());
            },
            child: SingleChildScrollView(
                child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // todo here...
                  SpacingSize.spacingBaseHeight,
                  Obx(() => DropdownInputWidget(
                      title: 'Kelas',
                      selected: controller.selectedItem.value,
                      items: controller.classItemList.toList(),
                      onChanged: (value) {
                        // do something
                        controller.selectedItem.value =
                            value ?? '(Pilih Kelas)';

                        if (value != null && value != '(Pilih Kelas)') {
                          final selectedId = controller.classMap[value];
                          log('Selected: $value, ID: $selectedId');
                          Fluttertoast.showToast(
                              msg: "Kelas: $value, ID: $selectedId");
                          controller.selectedClassId = selectedId!;
                          controller.fetchScheduleWeeklyTeacherByClass(
                              selectedId.toString());
                        } else {
                          controller.selectedClassId = BigInt.from(-1);
                        }
                      },
                      hint: '(Pilih Kelas)')),
                  SpacingSize.spacingBaseHeight,
                  CardScheduleWeeklyClassTeacher(
                    day: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'],
                    dateDay: controller.dateOfWeek,
                    controller: controller,
                  ),
                ],
              ),
            )),
          ),
        ));
  }
}
