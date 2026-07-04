import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/domain/enum/attendance_daily_status_enum.dart';
import 'package:flutter/material.dart';

class AttendanceStatusDailyBadge {
  final Color color;
  final String label;

  const AttendanceStatusDailyBadge({
    required this.color,
    required this.label,
  });
}

extension AttendanceStatusDailyBadgeExt on AttendanceDailyStatusEnum {
  AttendanceStatusDailyBadge get badge {
    switch (this) {
      case AttendanceDailyStatusEnum.ontime:
        return const AttendanceStatusDailyBadge(
          color: AppColor.colorPresent,
          label: 'Tepat Waktu',
        );
      case AttendanceDailyStatusEnum.late:
        return const AttendanceStatusDailyBadge(
          color: AppColor.colorLate,
          label: 'Telat',
        );
      case AttendanceDailyStatusEnum.izin:
        return const AttendanceStatusDailyBadge(
          color: AppColor.colorIzin,
          label: 'Izin',
        );
      case AttendanceDailyStatusEnum.none:
        return const AttendanceStatusDailyBadge(
          color: Colors.grey,
          label: 'Belum Absen',
        );
    }
  }
}
