import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TeacherSchedulePreviewCard extends StatelessWidget {
  const TeacherSchedulePreviewCard({
    super.key,
    required this.classTitle,
    required this.subjectName,
    required this.scheduleInfo,
    required this.codeQR,
    required this.idSchedule,
  });

  final String classTitle;
  final String subjectName;
  final String scheduleInfo; // e.g "08:00 - 09:00"
  final String codeQR;
  final BigInt idSchedule;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classTitle,
                    style: AppFontStyle.primaryText
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SpacingSize.spacingXSHeight,
                  Row(
                    children: [
                      SvgPicture.asset(
                        AssetConstant.svgIconSubject,
                        height: 16,
                        semanticsLabel: 'icon subject',
                      ),
                      SpacingSize.spacingXSWidth,
                      Text(
                        subjectName,
                        style: AppFontStyle.subTitleText,
                      ),
                    ],
                  ),
                  SpacingSize.spacingXSHeight,
                  Row(
                    children: [
                      Icon(Icons.schedule,
                          size: 16, color: AppColor.colorTextSubtitle),
                      SpacingSize.spacingXSWidth,
                      Text(
                        scheduleInfo,
                        style: AppFontStyle.subTitleText,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.scheduleQRTeacher, arguments: {
                  'codeQR': codeQR,
                  'subjectName': subjectName,
                  'idSchedule': idSchedule,
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AssetConstant.svgIconQR,
                    height: 30,
                    semanticsLabel: 'icon qr',
                  ),
                  SpacingSize.spacingXSHeight,
                  Text(
                    "Kode QR",
                    style: AppFontStyle.blueInfoText
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
