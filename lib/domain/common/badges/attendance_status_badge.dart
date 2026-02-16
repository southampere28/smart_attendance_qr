import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:flutter/material.dart';

class AttendanceStatusBadge {
  final Color color;
  final String label;

  const AttendanceStatusBadge({
    required this.color,
    required this.label,
  });
}

extension AttendanceStatusBadgeExt on AttendanceStatusEnum {
  AttendanceStatusBadge get badge {
    switch (this) {
      case AttendanceStatusEnum.valid:
        return const AttendanceStatusBadge(
          color: Colors.green,
          label: 'Sudah Absen',
        );
      case AttendanceStatusEnum.none:
        return const AttendanceStatusBadge(
          color: Colors.grey,
          label: 'Belum Absen',
        );
      case AttendanceStatusEnum.invalid:
        return const AttendanceStatusBadge(
          color: Colors.red,
          label: 'Tidak Hadir',
        );
      case AttendanceStatusEnum.sick:
        return const AttendanceStatusBadge(
          color: Colors.orange,
          label: 'Sakit',
        );
      case AttendanceStatusEnum.permission:
        return const AttendanceStatusBadge(
          color: Colors.blue,
          label: 'Izin',
        );
      case AttendanceStatusEnum.dispensation:
        return const AttendanceStatusBadge(
          color: Colors.purple,
          label: 'Dispensasi',
        );
      case AttendanceStatusEnum.alpha:
        return const AttendanceStatusBadge(
          color: Colors.redAccent,
          label: 'Alpha',
        );
    }
  }
}
