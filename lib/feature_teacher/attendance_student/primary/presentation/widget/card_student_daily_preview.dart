import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/widgets/attendance_status_daily_badge_widget.dart';
import 'package:absensi_qr/domain/common/badges/attendance_status_daily_badge.dart';
import 'package:absensi_qr/domain/enum/attendance_daily_status_enum.dart';
import 'package:flutter/material.dart';

class CardStudentDailyPreview extends StatelessWidget {
  const CardStudentDailyPreview(
      {super.key, required this.status, required this.studentName});

  final String studentName;
  final AttendanceDailyStatusEnum status;

  @override
  Widget build(BuildContext context) {
    // attendance badge
    final badge = status.badge;

    // color mapping for status
    Color getStatus() {
      switch (status) {
        case AttendanceDailyStatusEnum.ontime:
          return AppColor.colorOntime;
        case AttendanceDailyStatusEnum.late:
          return AppColor.colorLate;
        case AttendanceDailyStatusEnum.izin:
          return AppColor.colorIzin;
        case AttendanceDailyStatusEnum.none:
          return Colors.grey;
      }
    }

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 20, color: getStatus()),
                SpacingSize.spacingSMWidth,
                Expanded(
                  child: Text(
                    studentName,
                    style: AppFontStyle.primaryText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AttendanceStatusDailyBadgeWidget(
                  badge: badge,
                )
              ],
            ),
            SpacingSize.spacingXSHeight,
            Divider(
              color: AppColor.colorShadowBox,
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}
