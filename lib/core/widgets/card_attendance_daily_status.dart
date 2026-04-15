import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/helper/date_helper.dart';
import 'package:absensi_qr/domain/enum/attendance_daily_status_enum.dart';
import 'package:absensi_qr/models/attendance_daily.dart';
import 'package:flutter/material.dart';

class CardAttendanceDailyStatus extends StatelessWidget {
  const CardAttendanceDailyStatus({super.key, required this.attendance});

  final AttendanceDaily? attendance;

  @override
  Widget build(BuildContext context) {
    final timeFormatted = attendance?.createdAt != null
        ? DateHelper.formatToWIBTime(attendance!.createdAt!)
        : '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.today_rounded,
              color: AppColor.colorTextSubtitle, size: 24),
          SpacingSize.spacingSMWidth,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jam Absensi',
                  style: AppFontStyle.smallText.copyWith(color: Colors.black54),
                ),
                Text(
                  timeFormatted,
                  style:
                      AppFontStyle.subTitleText.copyWith(color: Colors.black87),
                ),
              ],
            ),
          ),
          attendance != null
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        attendance!.status == AttendanceDailyStatusEnum.ontime
                            ? Colors.green
                            : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    attendance!.status.title,
                    style: AppFontStyle.smallText.copyWith(color: Colors.white),
                  ),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Belum Absen',
                    style: AppFontStyle.smallText.copyWith(color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }
}
