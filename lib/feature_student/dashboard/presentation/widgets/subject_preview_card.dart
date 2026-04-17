import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/core/widgets/attendance_status_badge_widget.dart';
import 'package:absensi_qr/domain/common/badges/attendance_status_badge.dart';
import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:flutter/material.dart';

class SubjectPreviewCard extends StatelessWidget {
  const SubjectPreviewCard(
      {super.key,
      required this.subjectName,
      required this.teacherName,
      required this.scheduleInfo,
      required this.badgeInfo,
      this.isLive = false});

  final String subjectName;
  final String teacherName;
  final String scheduleInfo;

  final AttendanceStatusBadge badgeInfo; // next time change to enmm badge type
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final badge = badgeInfo;

    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.colorOutlineBoxinput, width: 1.0),
          boxShadow: isLive
              ? [
                  // radius shadow for box
                  BoxShadow(
                    color: AppColor.primaryColor,
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subjectName,
                  style: AppFontStyle.primaryText
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                AttendanceStatusBadgeWidget(badge: badge),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Pengajar: $teacherName',
              style: AppFontStyle.subTitleText,
            ),
            SizedBox(height: 4),
            Text(
              scheduleInfo,
              style: AppFontStyle.subTitleText,
            ),
          ],
        ));
  }
}
