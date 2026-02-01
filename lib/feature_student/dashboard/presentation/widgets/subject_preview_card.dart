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
      required this.badgeInfo});

  final String subjectName;
  final String teacherName;
  final String scheduleInfo;

  final String badgeInfo; // next time change to enmm badge type

  @override
  Widget build(BuildContext context) {
    final statusEnum = AttendanceStatusEnum.fromString(badgeInfo);

    final badge = statusEnum.badge;

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
