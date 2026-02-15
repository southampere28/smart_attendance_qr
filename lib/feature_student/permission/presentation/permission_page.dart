import 'dart:developer';

import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_student/permission/presentation/permission_controller.dart';
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
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Silahkan Isi Data Untuk Melakukan Perizinan',
                style: AppFontStyle.subTitleText),
            SpacingSize.spacingBaseHeight,
            Obx(() => DropdownInputWidget(
                title: 'Jenis Perizinan',
                selected: controller.typeSelected.value,
                items: controller.permissionType.toList(),
                onChanged: (value) {
                  // do something
                  controller.typeSelected.value =
                      value ?? '(Pilih Jenis Perizinan)';
                },
                hint: '(Pilih Jenis Perizinan)')),

            SpacingSize.spacingBaseHeight,
            Text('Jumlah Periode Perizinan'),

            SpacingSize.spacingBaseHeight,
            Text('Periode Jam Perizinan (untuk perizinan dispensasi)'),

            SpacingSize.spacingBaseHeight,
            Text('Tanggal, dan jumlah hari perizinan'),

            SpacingSize.spacingBaseHeight,
            // TextfieldWithTitle(
            //           title: 'Email',
            //           controller: controller.emailController,
            //           hintTxt: "Masukkan Email",
            //           keyboardType: TextInputType.emailAddress),

            TextareaWithTitle(
              title: 'Alasan Perizinan',
              controller: controller.reasonController,
              hintTxt:
                  'Jelaskan secara detail alasan perizinan anda di sini ....',
              keyboardType: TextInputType.text,
              minLines: 4,
              maxLines: 5,
            ),

            SpacingSize.spacingBaseHeight,
            Text('Bukti Pendukung Berupa Foto (Wajib)'),

            SpacingSize.spacingBaseHeight,
            Text('Tombol Submit Perizinan'),
          ],
        ),
      )),
    );
  }
}
