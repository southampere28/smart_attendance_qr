import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:flutter/material.dart';

class CardSubjectWeekly extends StatelessWidget {
  const CardSubjectWeekly({
    super.key,
    required this.subjectName,
    required this.teacherName,
    required this.scheduleInfo,
  });

  final String subjectName;
  final String teacherName;
  final String scheduleInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.colorOutlineBoxinput, width: 1.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subjectName,
              style: AppFontStyle.primaryText
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            SpacingSize.spacingXSHeight,
            Text(
              'Pengajar: $teacherName',
              style: AppFontStyle.subTitleText,
            ),
            SpacingSize.spacingXSHeight,
            Text(
              scheduleInfo,
              style: AppFontStyle.subTitleText,
            ),
          ],
        ));
  }
}
