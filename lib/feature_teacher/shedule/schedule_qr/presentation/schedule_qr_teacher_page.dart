import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_teacher/shedule/schedule_qr/presentation/schedule_qr_teacher_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qr_flutter/qr_flutter.dart';

class ScheduleQrTeacherPage extends StatelessWidget {
  const ScheduleQrTeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleQrTeacherController>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Kode QR',
          style: AppFontStyle.titleText.copyWith(color: Colors.black),
        ),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Kode QR Matematika',
              style: AppFontStyle.primaryText
                  .copyWith(fontWeight: FontWeight.bold)),
          SpacingSize.spacingXSHeight,
          Text(controller.dateNowFormatted, style: AppFontStyle.subTitleText),
          SpacingSize.spacingBaseHeight,
          // Container(
          //   width: 250,
          //   height: 250,
          //   color: Colors.grey[300],
          //   child: Center(child: Text('QR Code Placeholder')),
          // ),
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                QrImageView(
                  data: '1234567890',
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(4),
                  child: Image.asset('assets/icons/icon_app.png',
                      fit: BoxFit.contain),
                ),
              ],
            ),
          ),
          SpacingSize.spacingBaseHeight,
          Text('Pindai kode qr diatas untuk berbagi',
              style: AppFontStyle.subTitleText),
          SpacingSize.spacingXSHeight,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Salin Kode QR',
                  style: AppFontStyle.blueInfoText
                      .copyWith(fontWeight: FontWeight.w500)),
              SpacingSize.spacingXSWidth,
              Icon(Icons.copy, size: 16, color: AppColor.primaryColor),
            ],
          ),
        ],
      ),
    );
  }
}
