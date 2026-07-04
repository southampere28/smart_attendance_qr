import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_student/permission_detail/presentation/permission_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionDetailPage extends StatelessWidget {
  const PermissionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PermissionDetailController>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Detail Perizinan',
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
            Text('Detail Perizinan',
                style: AppFontStyle.subTitleText),
            SpacingSize.spacingBaseHeight,
            Text('Jenis Perizinan : Izin Sakit'),
            SpacingSize.spacingBaseHeight,
            Text('Jumlah Periode Perizinan : 3 Hari'),
            SpacingSize.spacingBaseHeight,
            Text('Periode Jam Perizinan : 07.00 - 15.00'),
            SpacingSize.spacingBaseHeight,
            Text('Tanggal, dan jumlah hari perizinan : 12-14 Juni 2024'),
          ],
        ),
      )),
    );
  }
}