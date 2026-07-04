import 'package:absensi_qr/domain/common/icons/attendance_status_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AttendanceStatusIconWidget extends StatelessWidget {
  const AttendanceStatusIconWidget({
    super.key, 
    required this.icon, 
    this.size = 46,
  });

  final AttendanceStatusIcon icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return icon.color != null ? SvgPicture.asset(
      icon.iconPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter:ColorFilter.mode(icon.color!, BlendMode.srcIn),
      semanticsLabel: 'attendance status icon',
    ) : SvgPicture.asset(
      icon.iconPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticsLabel: 'attendance status icon',
    );
  }
}