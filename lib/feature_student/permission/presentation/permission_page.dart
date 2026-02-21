import 'dart:developer';

import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_student/permission/presentation/permission_controller.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/features/widgets/dropdown_input_widget.dart';
import 'package:absensi_qr/features/widgets/textarea_with_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    PermissionController controller = Get.find<PermissionController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Perizinan',
          style: AppFontStyle.titleText.copyWith(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SpacingSize.spacingHugeHeight,
            Text('Riwayat Perizinan', style: AppFontStyle.subTitleText),
            SpacingSize.spacingBaseHeight,
            Text('Tidak ada riwayat perizinan'),
            SpacingSize.spacingHugeHeight,
            ButtonPrimaryWidget(
                borderRadius: 20,
                title: "Ajukan Perizinan",
                callback: () {
                  Get.toNamed(AppRoutes.permissionForm);
                }),
          ],
        ),
      )),
    );
  }
}
