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
        AppUtil.showLoadingDialog(context,
            message: 'Sedang mengirim perizinan...');
      } else {
        try {
          AppUtil.hideLoadingDialog(context);
        } catch (_) {}
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
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpacingSize.spacingXSHeight,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left,
                            color: Colors.black, size: 30),
                        onPressed: () {
                          Get.back();
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                      SpacingSize.spacingXSWidth,
                      Text(
                        'Perizinan',
                        style: AppFontStyle.titleText
                            .copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Silahkan Isi Data Untuk Melakukan Perizinan',
                      style: AppFontStyle.subTitleText,
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() => DropdownInputWidget(
                                title: 'Jenis Perizinan',
                                customTitleTextStyle: AppFontStyle.primaryText,
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
                                        controller:
                                            controller.datePickController,
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

                            SpacingSize.spacingXSHeight,
                            Row(
                              children: [
                                Icon(Icons.info_outline,
                                    size: 16, color: AppColor.primaryColor),
                                SpacingSize.spacingXSWidth,
                                Expanded(
                                  child: Text(
                                      'Izin melebihi 3 Hari memerlukan persetujuan kepala sekolah',
                                      style: AppFontStyle.blueInfoText
                                          .copyWith(fontSize: 10)),
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

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Bukti Pendukung',
                                    style: AppFontStyle.primaryText
                                        .copyWith(fontWeight: FontWeight.w500)),
                                GestureDetector(
                                  onTap: () {
                                    controller.showExampleImage();
                                  },
                                  child: Text(
                                    'Lihat Contoh Surat',
                                    style: AppFontStyle.smallText
                                        .copyWith(color: AppColor.primaryColor),
                                  ),
                                )
                              ],
                            ),
                            SpacingSize.spacingSMHeight,
                            // todo: area for upload image surat izin
                            Obx(() => controller.pickedImage.value != null
                                ? Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Image.file(
                                          File(controller
                                              .pickedImage.value!.path),
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
                                              color:
                                                  AppColor.colorOutlineBoxinput,
                                              width: 1),
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.upload_file,
                                              size: 40,
                                              color: AppColor.primaryColor),
                                          SpacingSize.spacingSMHeight,
                                          Text('Upload Surat Izin',
                                              style: AppFontStyle.primaryText
                                                  .copyWith(
                                                      color: AppColor
                                                          .primaryColor)),
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
                                }),
                            SpacingSize.spacingXLHeight,
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
