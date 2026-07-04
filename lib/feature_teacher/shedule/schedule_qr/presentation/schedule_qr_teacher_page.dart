import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_teacher/shedule/schedule_qr/presentation/schedule_qr_teacher_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';

class ScheduleQrTeacherPage extends StatefulWidget {
  const ScheduleQrTeacherPage({super.key});

  @override
  State<ScheduleQrTeacherPage> createState() => _ScheduleQrTeacherPageState();
}

class _ScheduleQrTeacherPageState extends State<ScheduleQrTeacherPage> {
  @override
  void initState() {
    super.initState();
    _setMaxBrightness();
  }

  Future<void> _setMaxBrightness() async {
    try {
      await ScreenBrightness().setApplicationScreenBrightness(1.0);
    } catch (e) {
      debugPrint('Gagal menaikkan brightness: $e');
    }
  }

  Future<void> _resetBrightness() async {
    try {
      await ScreenBrightness().resetApplicationScreenBrightness();
    } catch (e) {
      debugPrint('Gagal reset brightness: $e');
    }
  }

  @override
  void dispose() {
    _resetBrightness();
    super.dispose();
  }

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
          Text('Kode QR ${controller.subjectName ?? 'N/A'}',
              style: AppFontStyle.primaryText
                  .copyWith(fontWeight: FontWeight.bold)),
          SpacingSize.spacingXSHeight,
          Text(controller.dateSchedule ?? controller.dateNowFormatted,
              style: AppFontStyle.subTitleText),
          SpacingSize.spacingBaseHeight,
          controller.codeQR != null
              ? SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      QrImageView(
                        data: controller.codeQR!,
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
                        child: Icon(Icons.qr_code,
                            size: 24, color: AppColor.primaryColor),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: 200,
                  height: 200,
                  color: AppColor.colorOutlineBoxinput,
                  child: Center(
                    child: Text('QR Code tidak tersedia',
                        style: AppFontStyle.subTitleText),
                  ),
                ),
          SpacingSize.spacingBaseHeight,
          Text('Pindai kode qr diatas untuk berbagi',
              style: AppFontStyle.subTitleText),
          SpacingSize.spacingXSHeight,
          GestureDetector(
            onTap: () {
              controller.copyCodeQRToClipboard();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Salin Kode QR',
                    style: AppFontStyle.blueInfoText
                        .copyWith(fontWeight: FontWeight.w500)),
                SpacingSize.spacingXSWidth,
                Icon(Icons.copy, size: 16, color: AppColor.primaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
