import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/features/others/splash_screen/presentation/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    SplashScreenController controller = Get.find<SplashScreenController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(children: [
          Expanded(flex: 4, child: SizedBox()),
          Text(
            'Splash Screen Page',
            style: AppFontStyle.titleText,
          ),
          SizedBox(
            height: 30,
          ),
          Obx(() => Text(
                controller.messageLoading.value,
                style: AppFontStyle.smallText,
              )),
          Expanded(flex: 3, child: SizedBox()),
        ]),
      ),
    );
  }
}
