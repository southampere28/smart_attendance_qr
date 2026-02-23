import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/widgets/attendance_status_badge_widget.dart';
import 'package:absensi_qr/domain/common/badges/attendance_status_badge.dart';
import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:flutter/material.dart';

class CardAttendanceDateSchedule extends StatelessWidget {
  const CardAttendanceDateSchedule({
    super.key,
    required this.subjectName,
    this.attendanceDateTime, 
    required this.badgeInfo});

  final String subjectName;
  final DateTime? attendanceDateTime;
  final String badgeInfo;

  @override
  Widget build(BuildContext context) {
    final statusEnum = AttendanceStatusEnum.fromString(badgeInfo);
    final badge = statusEnum.badge;

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Icon(Icons.book, size: 24, color: AppColor.primaryColor),
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
                          Text(subjectName,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(attendanceDateTime != null
                              ? '${attendanceDateTime!.hour}:${attendanceDateTime!.minute.toString().padLeft(2, '0')} WIB'
                              : '(waktu tidak tersedia)',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ),
                    SpacingSize.spacingBaseWidth,
                    AttendanceStatusBadgeWidget(badge: badge),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Divider(color: Colors.grey.shade300, thickness: 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
