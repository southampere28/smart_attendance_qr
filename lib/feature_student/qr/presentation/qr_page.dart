import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/feature_student/qr/presentation/qr_controller.dart';
import 'package:absensi_qr/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrPage extends StatelessWidget {
  const QrPage({super.key});

  @override
  Widget build(BuildContext context) {
    QrController controller = Get.find<QrController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Qr Code Scan'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              width: double.infinity,
              color: Colors.white,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Place the QR Code in this area'),
                  Text('Scanning will be started automatically'),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            )),
            Expanded(
                flex: 4,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        height: MediaQuery.of(context).size.width - 50,
                        width: MediaQuery.of(context).size.width - 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: MobileScanner(
                              allowDuplicates: false,
                              controller: controller.scannerController,
                              onDetect: (barcode, args) {
                                if (!controller.isScanCompleted) {
                                  if (barcode.rawValue == null) {
                                    debugPrint('Failed to scan Barcode');
                                  } else {
                                    final String code = barcode.rawValue!;
                                    debugPrint('Barcode found! $code');
                                    controller.isScanCompleted =
                                        true; // tandai scan selesai

                                    if (controller.userData != null) {
                                      if (controller.userData!.student ==
                                          null) {
                                        Fluttertoast.showToast(
                                            msg: 'Anda bukan siswa!');
                                        Get.back();
                                      } else {
                                        var studentId = controller
                                            .userData!.student!.id
                                            .toString();
                                        var classId = controller
                                            .userData!.student!.idClass
                                            .toString();

                                        controller.startScan(
                                          context: context,
                                            idStudent: studentId,
                                            idClass: classId,
                                            qrcode: code);
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Silahkan Login Terlebih dahulu!');
                                      Get.offAllNamed(AppRoutes.login);
                                    }
                                  }
                                }
                              },
                            )),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 40,
                          height: 4,
                          color: Colors.blue,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 4,
                          height: 40,
                          color: Colors.blue,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 40,
                          height: 4,
                          color: Colors.blue,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 4,
                          height: 40,
                          color: Colors.blue,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: 40,
                          height: 4,
                          color: Colors.blue,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: 4,
                          height: 40,
                          color: Colors.blue,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 40,
                          height: 4,
                          color: Colors.blue,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 4,
                          height: 40,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 30),
                color: AppColor.primaryColor,
                child: Center(
                  child: Text(
                    'qrscanner developed by Pramudya',
                    style: AppFontStyle.whiteText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
