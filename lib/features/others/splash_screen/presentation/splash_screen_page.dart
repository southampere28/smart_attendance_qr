import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/features/others/splash_screen/presentation/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    SplashScreenController controller = Get.find<SplashScreenController>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            AssetConstant.iconApp,
            width: 120,
            fit: BoxFit.contain,
          ),
          SpacingSize.spacingSMHeight,
          // text 2 row
          Text(
            'ATTENDANCE SYSTEM',
            style: AppFontStyle.titleText,
          ),
          // loading circular bar
          SpacingSize.spacingMDHeight,
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.infoColor),
          ),
          Obx(() => Text(
                controller.messageLoading.value,
                style: AppFontStyle.smallText,
              )),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.chooserRoleUser);
        },
        child: const Icon(Icons.skip_next),
      ),
    );
  }
}
