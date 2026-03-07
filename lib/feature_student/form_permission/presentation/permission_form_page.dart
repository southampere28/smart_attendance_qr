import 'dart:async';
import 'dart:io';

import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_student/form_permission/presentation/permission_form_controller.dart';
import 'package:absensi_qr/features/widgets/button_confirmation_widget.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/features/widgets/datepicker_input_withtitle.dart';
import 'package:absensi_qr/features/widgets/dropdown_input_widget.dart';
import 'package:absensi_qr/features/widgets/textarea_with_title.dart';
import 'package:absensi_qr/features/widgets/textfield_with_title.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionFormPage extends StatefulWidget {
  const PermissionFormPage({super.key});

  @override
  State<PermissionFormPage> createState() => _PermissionFormPageState();
}

class _PermissionFormPageState extends State<PermissionFormPage> {
  final controller = Get.find<PermissionFormController>();
  late final StreamSubscription<bool> _loadingSub;

  @override
  void initState() {
    super.initState();
    _loadingSub = controller.isloadingSubmit.listen((loading) {
      if (loading) {
        AppUtil.showLoadingDialog(context, message: 'Sedang mengirim perizinan...');
      } else {
        try { AppUtil.hideLoadingDialog(context); } catch (_) {}
      }
    });
  }

  @override
  void dispose() {
    _loadingSub.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

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
                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: DatepickerInputWithtitle(
                            title: 'Tanggal Perizinan',
                            controller: controller.datePickController,
                            hintTxt: 'Pilih Tanggal Perizinan')),
                    SpacingSize.spacingXSWidth,
                    Expanded(
                      flex: 2,
                      child: TextfieldWithTitle(
                          title: 'Jumlah Hari',
                          controller: controller.dayCountController,
                          hintTxt: '0',
                          keyboardType: TextInputType.number),
                    ),
                  ],
                ),

                SpacingSize.spacingBaseHeight,

                TextareaWithTitle(
                  title: 'Alasan Perizinan',
                  controller: controller.infoPermitController,
                  hintTxt:
                      'Jelaskan secara detail alasan perizinan anda di sini ....',
                  keyboardType: TextInputType.text,
                  minLines: 4,
                  maxLines: 5,
                ),

                SpacingSize.spacingBaseHeight,
                // todo: area for upload image surat izin
                Obx(() => controller.pickedImage.value != null
                    ? Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Image.file(
                              File(controller.pickedImage.value!.path),
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            SpacingSize.spacingSMHeight,
                            ButtonPrimaryWidget(
                                borderRadius: 20,
                                title: "Ganti Foto Surat Izin",
                                callback: () {
                                  controller.pickImage();
                                }),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          controller.pickImage();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColor.colorOutlineBoxinput,
                                  width: 1),
                              color: AppColor.backgroundColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.upload_file,
                                  size: 40, color: AppColor.primaryColor),
                              SpacingSize.spacingSMHeight,
                              Text('Upload Surat Izin',
                                  style: AppFontStyle.primaryText
                                      .copyWith(color: AppColor.primaryColor)),
                              SpacingSize.spacingSMHeight,
                              Text(
                                'Maksimal file 5MB (JPG, JPEG, PNG)',
                                style: AppFontStyle.subTitleText
                                    .copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      )),

                SpacingSize.spacingBaseHeight,

                ButtonConfirmationWidget(
                    borderRadius: 20,
                    title: "Kirim",
                    callback: () {
                      // Handle positive action
                      controller.validateAndSubmit();
                    },
                    titleNegative: "Batal",
                    callbackNegative: () {
                      // Handle negative action
                    })
              ]),
        )));
  }
}
