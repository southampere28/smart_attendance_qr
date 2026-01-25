import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/widgets/button_text_primary.dart';
import 'package:absensi_qr/features/others/choose_role/choose_role_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChooseRolePage extends StatelessWidget {
  const ChooseRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChooseRoleController>();

    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Spacer(
            flex: 10,
          ),
          Image.asset(
            AssetConstant.iconApp,
            width: 105,
            fit: BoxFit.contain,
          ),
          SpacingSize.spacingSMHeight,
          Text(
            'ATTENDANCE',
            style: AppFontStyle.titleText
                .copyWith(fontSize: 18)
                .copyWith(height: 1.0),
          ),
          Text(
            'SYSTEM',
            style: AppFontStyle.titleText.copyWith(fontSize: 18),
          ),
          SpacingSize.spacingLGHeight,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Silahkan Pilih Role Anda untuk Melanjutkan',
              style: AppFontStyle.primaryText,
            ),
          ),
          SpacingSize.spacingLGHeight,
          ButtonTextPrimary(
              text: 'Siswa',
              onPressed: () {
                Get.toNamed(AppRoutes.login, arguments: 'student');
              }),
          SpacingSize.spacingBaseHeight,
          ButtonTextPrimary(
            text: 'Guru',
            onPressed: () {
              Get.toNamed(AppRoutes.login, arguments: 'teacher');
            },
          ),
          Spacer(
            flex: 9,
          ),
        ],
      ),
    ));
  }
}
