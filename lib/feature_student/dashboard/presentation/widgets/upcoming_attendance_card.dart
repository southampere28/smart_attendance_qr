import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/helper/date_helper.dart';
import 'package:absensi_qr/core/widgets/attendance_status_badge_widget.dart';
import 'package:absensi_qr/core/widgets/attendance_status_icon_widget.dart';
import 'package:absensi_qr/domain/common/badges/attendance_status_badge.dart';
import 'package:absensi_qr/domain/common/icons/attendance_status_icon.dart';
import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:flutter/material.dart';

class UpcomingAttendanceCard extends StatelessWidget {
  const UpcomingAttendanceCard(
      {super.key,
      required this.timeStart,
      required this.timeEnd,
      required this.subjectName,
      required this.teacherName,
      required this.attendanceStatus});

  final DateTime timeStart;
  final DateTime timeEnd;
  final String subjectName;
  final String teacherName;
  final AttendanceStatusEnum attendanceStatus;

  @override
  Widget build(BuildContext context) {
    // normalize date for time start and time end to datetime now, becase the date is not important, only the time is important
    final now = DateTime.now();
    final normalizedTimeStart = DateTime(
        now.year, now.month, now.day, timeStart.hour, timeStart.minute);
    final normalizedTimeEnd =
        DateTime(now.year, now.month, now.day, timeEnd.hour, timeEnd.minute);

    final attendanceIcon = attendanceStatus.icondata;
    final statusTimeAttending = DateHelper.statusUpcomingAttendance(
        normalizedTimeStart, normalizedTimeEnd);
    final badge = attendanceStatus.badge;
    final countdownToEnd = DateHelper.countDownTimer(
      normalizedTimeEnd
    );

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Absensi berikutnya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  countdownToEnd,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        statusTimeAttending,
                        style: AppFontStyle.blueInfoText
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SpacingSize.spacingSMHeight,
                      Text(
                        subjectName,
                        style: AppFontStyle.titleText,
                      ),
                      SpacingSize.spacingBaseHeight,
                      Row(
                        children: [
                          Icon(Icons.person,
                              size: 16, color: AppColor.primaryColor),
                          SpacingSize.spacingSMWidth,
                          Expanded(
                              child: Text(teacherName,
                                  style: AppFontStyle.subTitleText))
                        ],
                      ),
                    ],
                  ),
                ),
                SpacingSize.spacingXSWidth,
                // icon section
                Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AttendanceStatusIconWidget(icon: attendanceIcon),
                        SpacingSize.spacingBaseHeight,
                        AttendanceStatusBadgeWidget(badge: badge),
                      ],
                    ))
              ],
            ),
          ),
          // header
        ],
      ),
    );
  }
}
