import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:flutter/material.dart';

class AttendanceStatusIcon {
  final Color? color;
  final String iconPath;

  const AttendanceStatusIcon({
    this.color,
    required this.iconPath,
  });
}

extension AttendanceStatusIconExt on AttendanceStatusEnum {
  AttendanceStatusIcon get icondata {
    switch (this) {
      case AttendanceStatusEnum.valid:
        return const AttendanceStatusIcon(
          iconPath: AssetConstant.iconAttValid,
        );
      case AttendanceStatusEnum.none:
        return const AttendanceStatusIcon(
          // color: Colors.grey,
          iconPath: AssetConstant.iconAttNone,
        );
      case AttendanceStatusEnum.invalid:
        return const AttendanceStatusIcon(
          // color: Colors.red,
          iconPath: AssetConstant.iconAttNone,
        );
      case AttendanceStatusEnum.sick:
        return const AttendanceStatusIcon(
          // color: Colors.orange,
          iconPath: AssetConstant.iconAttNone,
        );
      case AttendanceStatusEnum.permission:
        return const AttendanceStatusIcon(
          // color: Colors.blue,
          iconPath: AssetConstant.iconAttNone,
        );
      case AttendanceStatusEnum.dispensation:
        return const AttendanceStatusIcon(
          // color: Colors.purple,
          iconPath: AssetConstant.iconAttNone,
        );
      case AttendanceStatusEnum.alpha:
        return const AttendanceStatusIcon(
          // color: Colors.redAccent,
          iconPath: AssetConstant.iconAttNone,
        );
    }
  }
}
