import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/domain/common/badges/attendance_status_daily_badge.dart';
import 'package:flutter/material.dart';

class AttendanceStatusDailyBadgeWidget extends StatelessWidget {
  const AttendanceStatusDailyBadgeWidget({super.key, required this.badge, this.customWidth, this.customHeight});

  final AttendanceStatusDailyBadge badge;
  final double? customWidth;
  final double? customHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: customWidth,
      height: customHeight,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: badge.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        badge.label,
        style: AppFontStyle.primaryText
            .copyWith(color: Colors.white, fontSize: 10),
      ),
    );
  }
}
