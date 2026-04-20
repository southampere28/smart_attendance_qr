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
          color: Colors.green,
          label: 'Telah Absen',
        );
      case AttendanceDailyStatusEnum.late:
        return const AttendanceStatusDailyBadge(
          color: Colors.red,
          label: 'Telat',
        );
      case AttendanceDailyStatusEnum.none:
        return const AttendanceStatusDailyBadge(
          color: Colors.grey,
          label: 'Belum Absen',
        );
    }
  }
}
