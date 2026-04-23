import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_teacher/attendance_student/primary/presentation/widget/compact_button.dart';
import 'package:absensi_qr/models/model_merging/schedule_student_attendance_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CardSchedulePreview extends StatelessWidget {
  const CardSchedulePreview({
    super.key,
    required this.schedulewithAttendance,
  });

  final ScheduleStudentAttendanceReport schedulewithAttendance;

  @override
  Widget build(BuildContext context) {
    final formattedTimeSchedule =
        '${schedulewithAttendance.schedule.startTime.hour}:${schedulewithAttendance.schedule.startTime.minute.toString().padLeft(2, '0')}-${schedulewithAttendance.schedule.endTime.hour}:${schedulewithAttendance.schedule.endTime.minute.toString().padLeft(2, '0')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SvgPicture.asset(AssetConstant.svgIconSubjectThin,
              width: 24, height: 24),
          SpacingSize.spacingMDWidth,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(schedulewithAttendance.subject?.name ?? '-',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(formattedTimeSchedule,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ),
                    SpacingSize.spacingBaseWidth,
                    CompactButton(
                      title: 'Lihat Detail',
                      onPressed: () {
                        Get.toNamed(AppRoutes.detailAttendanceStudentClass,
                            arguments: schedulewithAttendance);
                      },
                      textStyle: AppFontStyle.whiteText.copyWith(
                        fontSize: 12,
                        height: 1,
                      ),
                    )
                  ],
                ),
                SpacingSize.spacingXSHeight,
                Divider(
                  color: AppColor.colorOutlineBoxinput,
                  thickness: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
