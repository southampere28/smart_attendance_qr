import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/feature_student/schedule/presentation/schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardPickdateWeekly extends StatelessWidget {
  const CardPickdateWeekly({
    super.key,
    required this.day,
    required this.dateDay,
    required this.controller,
  });

  final List<String> day; // example: ['Mon', 'Tue', 'Wed', ...]
  final List<String> dateDay; // example: ['01', '02', '03', ...]
  final ScheduleController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int indexSelected = controller.indexSelected.value;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(day.length, (index) {
            final bool isSelected = index == indexSelected;

            final titleStyle = isSelected
                ? AppFontStyle.smallText.copyWith(color: AppColor.primaryColor)
                : AppFontStyle.smallText.copyWith(
                    color: AppColor.colorTextSubtitle,
                  );

            final dateStyle = isSelected
                ? AppFontStyle.blueInfoText.copyWith(fontSize: 20)
                : AppFontStyle.primaryText.copyWith(
                    color: AppColor.colorTextSubtitle,
                    fontSize: 20,
                  );

            return GestureDetector(
              onTap: () {
                controller.indexSelected.value = index;
                controller.filterScheduleByDay(index);
              },
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.backgroundColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(day[index], style: titleStyle),
                    const SizedBox(height: 4),
                    Text(dateDay[index], style: dateStyle),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
