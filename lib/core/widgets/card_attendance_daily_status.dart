import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/helper/date_helper.dart';
import 'package:absensi_qr/core/widgets/attendance_status_daily_badge_widget.dart';
import 'package:absensi_qr/domain/common/badges/attendance_status_daily_badge.dart';
import 'package:absensi_qr/domain/enum/attendance_daily_status_enum.dart';
import 'package:absensi_qr/models/attendance_daily.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardAttendanceDailyStatus extends StatelessWidget {
  const CardAttendanceDailyStatus({super.key, required this.attendance});

  final AttendanceDaily? attendance;

  @override
  Widget build(BuildContext context) {
    final timeFormatted = attendance?.createdAt != null
        ? DateHelper.formatToWIBTime(attendance!.createdAt!)
        : '-';

    final isStatusAttendanceNotNone = attendance != null &&
        attendance!.status != AttendanceDailyStatusEnum.none;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AssetConstant.iconDailyAttendance,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isStatusAttendanceNotNone
                  ? AppColor.colorPresent
                  : AppColor.colorTextSubtitle,
              BlendMode.srcIn,
            ),
          ),
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
              ? AttendanceStatusDailyBadgeWidget(
                  badge: attendance!.status.badge)
              : AttendanceStatusDailyBadgeWidget(
                  badge: AttendanceDailyStatusEnum.none.badge,
                ),
        ],
      ),
    );
  }
}
