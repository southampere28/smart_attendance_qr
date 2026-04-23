import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/widgets/attendance_status_badge_widget.dart';
import 'package:absensi_qr/domain/common/badges/attendance_status_badge.dart';
import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SubjectPreviewCard extends StatelessWidget {
  const SubjectPreviewCard(
      {super.key,
      required this.subjectName,
      required this.startedAt,
      required this.endedAt,
      required this.badgeInfo});

  final String subjectName;
  final DateTime startedAt;
  final DateTime endedAt;
  final AttendanceStatusEnum badgeInfo;

  @override
  Widget build(BuildContext context) {
    final badge = badgeInfo.badge;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SvgPicture.asset(AssetConstant.svgIconSubjectThin,
              width: 24, height: 24),
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
                          Text(
                              '${startedAt.hour}:${startedAt.minute.toString().padLeft(2, '0')}-${endedAt.hour}:${endedAt.minute.toString().padLeft(2, '0')}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ),
                    SpacingSize.spacingBaseWidth,
                    AttendanceStatusBadgeWidget(badge: badge),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
