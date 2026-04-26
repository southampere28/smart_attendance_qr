import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/feature_student/qr/presentation/qr_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrPage extends StatelessWidget {
  const QrPage({super.key});

  @override
  Widget build(BuildContext context) {
    QrController controller = Get.find<QrController>();
    final double scanBoxSize = MediaQuery.of(context).size.width - 90;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Absensi', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.chevron_left, color: Colors.white, size: 30)),
      ),
      body: Stack(
        children: [
          // Full screen camera
          SizedBox.expand(
            child: MobileScanner(
              fit: BoxFit.cover,
              allowDuplicates: false,
              controller: controller.scannerController,
              onDetect: (barcode, args) {
                if (!controller.isScanCompleted) {
                  if (barcode.rawValue == null) {
                    debugPrint('Failed to scan Barcode');
                  } else {
                    final String code = barcode.rawValue!;
                    debugPrint('Barcode found! $code');
                    controller.isScanCompleted = true; // tandai scan selesai

                    if (controller.userData != null) {
                      if (controller.userData!.student == null) {
                        Fluttertoast.showToast(msg: 'Anda bukan siswa!');
                        Get.back();
                      } else {
                        if (controller.userData == null) {
                          Fluttertoast.showToast(
                              msg: 'Silahkan Login Terlebih dahulu!');
                          Get.offNamed(AppRoutes.login);
                          return;
                        }

                        var studentId =
                            controller.userData!.student!.id.toString();
                        var classId =
                            controller.userData!.student!.idClass.toString();

                        controller.startScan(
                            context: context,
                            idStudent: studentId,
                            idClass: classId,
                            qrcode: code);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Silahkan Login Terlebih dahulu!');
                      Get.offAllNamed(AppRoutes.login);
                    }
                  }
                }
              },
            ),
          ),

          // Dark overlay with transparent cutout in center
          CustomPaint(
            painter: _ScanOverlayPainter(scanBoxSize: scanBoxSize),
            child: const SizedBox.expand(),
          ),

          // Corner bracket decorations
          Center(
            child: SizedBox(
              width: scanBoxSize + 20,
              height: scanBoxSize + 20,
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      child:
                          Container(width: 40, height: 4, color: Colors.white)),
                  Positioned(
                      top: 0,
                      left: 0,
                      child:
                          Container(width: 4, height: 40, color: Colors.white)),
                  Positioned(
                      top: 0,
                      right: 0,
                      child:
                          Container(width: 40, height: 4, color: Colors.white)),
                  Positioned(
                      top: 0,
                      right: 0,
                      child:
                          Container(width: 4, height: 40, color: Colors.white)),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child:
                          Container(width: 40, height: 4, color: Colors.white)),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child:
                          Container(width: 4, height: 40, color: Colors.white)),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child:
                          Container(width: 40, height: 4, color: Colors.white)),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child:
                          Container(width: 4, height: 40, color: Colors.white)),
                ],
              ),
            ),
          ),

          // Bottom label
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Arahkan ke Kode QR',
                style: AppFontStyle.primaryText.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  final double scanBoxSize;

  const _ScanOverlayPainter({required this.scanBoxSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.55);

    final scanBoxLeft = (size.width - scanBoxSize) / 2;
    final scanBoxTop = (size.height - scanBoxSize) / 2;
    final scanRect =
        Rect.fromLTWH(scanBoxLeft, scanBoxTop, scanBoxSize, scanBoxSize);

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(scanRect, const Radius.circular(4)));
    path.fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
