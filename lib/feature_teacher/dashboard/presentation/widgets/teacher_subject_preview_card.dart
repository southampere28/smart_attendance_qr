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
  });

  final String classTitle;
  final String subjectName;
  final String scheduleInfo; // e.g "08:00 - 09:00"

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.colorOutlineBoxinput, width: 1.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  classTitle,
                  style: AppFontStyle.primaryText
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  scheduleInfo,
                  style: AppFontStyle.subTitleText,
                )
              ],
            ),
            SizedBox(height: 4),
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
            SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.scheduleQRTeacher);
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    AssetConstant.svgIconQR,
                    height: 16,
                    semanticsLabel: 'icon qr',
                  ),
                  SpacingSize.spacingXSWidth,
                  Text(
                    "Tampilkan QR",
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
