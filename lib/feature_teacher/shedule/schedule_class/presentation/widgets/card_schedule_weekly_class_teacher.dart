import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/widgets/shimmer_load_card.dart';
import 'package:absensi_qr/feature_teacher/shedule/schedule_class/presentation/schedule_class_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CardScheduleWeeklyClassTeacher extends StatelessWidget {
  const CardScheduleWeeklyClassTeacher(
      {super.key,
      required this.day,
      required this.dateDay,
      required this.controller});

  final List<String> day; // example: ['Mon', 'Tue', 'Wed', ...]
  final List<String> dateDay; // example: ['01', '02', '03', ...]
  final ScheduleClassController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int indexSelected = controller.indexSelected.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(
          //   color: AppColor.colorOutlineBoxinput,
          //   width: 1.0,
          // ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(controller.monthYearOfWeek,
                style: AppFontStyle.primaryText
                    .copyWith(fontWeight: FontWeight.bold)),
            SpacingSize.spacingMDHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(day.length, (index) {
                  final bool isSelected = index == indexSelected;

                  final titleStyle = isSelected
                      ? AppFontStyle.smallText
                          .copyWith(color: AppColor.primaryColor)
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
            ),
            Divider(
              color: AppColor.colorOutlineBoxinput,
              thickness: 1,
            ),
            // schedule list area...
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Jadwal Kelas',
                style: AppFontStyle.subTitleText,
                textAlign: TextAlign.start,
              ),
            ),

            SpacingSize.spacingSMHeight,

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                final scheduleList = controller.filteredSchedule;
                if (controller.isLoading.value) {
                  return ShimmerLoadCard(
                    shimmerItemCount: 3,
                  );
                } else if (scheduleList.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada jadwal untuk hari ini.',
                      style: AppFontStyle.subTitleText,
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: scheduleList.length,
                    itemBuilder: (context, index) {
                      final item = scheduleList[index];
                      final classTitle = item.classModel?.name ?? 'N/A';
                      final subjectName = item.subject?.name ?? 'N/A';
                      final startTime =
                          '${item.schedule.startTime.hour.toString().padLeft(2, '0')}:${item.schedule.startTime.minute.toString().padLeft(2, '0')}';
                      final endTime =
                          '${item.schedule.endTime.hour.toString().padLeft(2, '0')}:${item.schedule.endTime.minute.toString().padLeft(2, '0')}';
                      final scheduleInfo = '$startTime - $endTime';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildSceduleCard(classTitle, subjectName,
                            scheduleInfo, item.schedule.code, item.schedule.id),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSceduleCard(String classTitle, String subjectName,
      String scheduleInfo, String codeQR, BigInt idSchedule) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
            bottom:
                BorderSide(color: AppColor.colorOutlineBoxinput, width: 1.0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classTitle,
                  style: AppFontStyle.primaryText
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    SvgPicture.asset(
                      AssetConstant.svgIconSubject,
                      height: 16,
                      semanticsLabel: 'icon subject',
                    ),
                    SpacingSize.spacingXSWidth,
                    Text(
                      subjectName,
                      style: AppFontStyle.subTitleText,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.schedule,
                        size: 16, color: AppColor.colorTextSubtitle),
                    SpacingSize.spacingXSWidth,
                    Expanded(
                      child: Text(
                        '$scheduleInfo WIB',
                        style: AppFontStyle.subTitleText,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.scheduleQRTeacher, arguments: {
                'codeQR': codeQR,
                'subjectName': subjectName,
                'dateSchedule': controller.getDateOfSelectedSchedule(),
                'idSchedule': idSchedule,
              });
            },
            child: SvgPicture.asset(
              AssetConstant.svgIconQR,
              height: 30,
              semanticsLabel: 'icon qr',
            ),
          ),
        ],
      ),
    );
  }
}
