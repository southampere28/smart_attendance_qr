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
      padding: EdgeInsets.only(bottom: 6, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subjectName,
            style:
                AppFontStyle.primaryText.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.person,
                size: 16,
                color: AppColor.primaryColor,
              ),
              SpacingSize.spacingXSWidth,
              Text(
                teacherName,
                style: AppFontStyle.subTitleText,
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: AppColor.colorTextSubtitle),
              SpacingSize.spacingXSWidth,
              Expanded(
                child: Text(
                  '$scheduleInfo WIB',
                  style: AppFontStyle.subTitleText,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            color: AppColor.colorOutlineBoxinput,
          ),
        ],
      ),
    );
  }
}
