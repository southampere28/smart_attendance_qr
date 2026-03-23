import 'dart:developer';
import 'dart:ffi';

import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_teacher/student_class/info_class/presentation/detail_information_class_controller.dart';
import 'package:absensi_qr/feature_teacher/student_class/info_class/presentation/widgets/card_student_member.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/features/widgets/dropdown_input_widget.dart';
import 'package:absensi_qr/models/class_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailInformationClassPage extends StatelessWidget {
  const DetailInformationClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailInformationClassController>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Informasi Kelas',
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
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SpacingSize.spacingBaseHeight,
              Obx(() => DropdownInputWidget(
                  title: 'Kelas',
                  selected: controller.selectedItem.value,
                  items: controller.classItemList.toList(),
                  onChanged: (value) {
                    // do something
                    controller.selectedItem.value = value ?? '(Pilih Kelas)';

                    if (value != null && value != '(Pilih Kelas)') {
                      final selectedId = controller.classMap[value];
                      log('Selected: $value, ID: $selectedId');
                      controller.selectedClassId = selectedId!;
                      controller.fetchDetailClass(
                          controller.selectedClassId.toString());
                    } else {
                      controller.selectedClassId = BigInt.from(-1);
                    }
                  },
                  hint: '(Pilih Kelas)')),

              SpacingSize.spacingBaseHeight,
              // card information class
              Obx(
                () => _buildCardInformationClass(
                  classData: controller.classInfo.value?.classModel,
                ),
              ),
              SpacingSize.spacingBaseHeight,
              Obx(() => CardStudentMember(
                    studentList: controller.classInfo.value?.students ?? [],
                    nullStudentCallback: controller.classInfo.value == null
                        ? 'Belum Ada Kelas yang Dipilih'
                        : 'Tidak ada data siswa yang ditemukan.',
                  )),

              SpacingSize.spacingBaseHeight,
              // button action (send announcement and view attendance history)
              Row(
                children: [
                  Expanded(
                      child: ButtonPrimaryWidget(
                          // margin: const EdgeInsets.symmetric(horizontal: 20),
                          borderRadius: 20,
                          title: "Pengumuman",
                          callback: () {
                            // Get.toNamed(AppRoutes.detailInformationClass);
                            Get.toNamed(AppRoutes.sendAnnouncement, arguments: {
                              'classId': int.parse(controller.selectedClassId.toString()),
                              'className': controller.selectedItem.value,
                            });
                          })),
                  SpacingSize.spacingMDWidth,
                  Expanded(
                    child: ButtonPrimaryWidget(
                      // margin: const EdgeInsets.symmetric(horizontal: 20),
                      borderRadius: 20,
                      title: "History",
                      callback: () {
                        // Handle view attendance history action
                      },
                    ),
                  ),
                ],
              ),
              // card list of student in class
              SpacingSize.spacingHugeHeight,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardInformationClass({ClassModel? classData}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Kelas',
            style: AppFontStyle.subTitleText,
          ),
          SpacingSize.spacingSMHeight,
          (classData != null)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tingkatan : ${classData.grade}',
                      style: AppFontStyle.primaryText,
                    ),
                    SpacingSize.spacingXSHeight,
                    Text(
                      'Jurusan : ${classData.major}',
                      style: AppFontStyle.primaryText,
                    ),
                    SpacingSize.spacingXSHeight,
                    Text(
                      'Nama Kelas : ${classData.name}',
                      style: AppFontStyle.primaryText,
                    ),
                    SpacingSize.spacingXSHeight,
                  ],
                )
              : Container(
                  width: double.infinity,
                  height: 80,
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'Belum Ada Kelas yang Dipilih',
                      style: AppFontStyle.primaryText,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
