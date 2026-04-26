import 'dart:developer';

import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_teacher/permission/presentation/teacher_permission_controller.dart';
import 'package:absensi_qr/feature_teacher/permission/presentation/widgets/card_preview_permission_student.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/features/widgets/datepicker_input_withtitle.dart';
import 'package:absensi_qr/features/widgets/dropdown_input_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherPermissionPage extends StatelessWidget {
  const TeacherPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    TeacherPermissionController controller =
        Get.find<TeacherPermissionController>();

    return SizedBox(
      width: double.infinity,
      child: RefreshIndicator(
        onRefresh: () async {
          if (controller.selectedClassId != BigInt.from(-1)) {
            await controller.getDataPermissionByClass(
                controller.selectedClassId.toString());
          }
        },
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Perizinan',
                          style: AppFontStyle.titleText
                              .copyWith(color: Colors.black),
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            _showFilterBottomSheet(context, controller),
                        icon: const Icon(Icons.tune),
                        color: AppColor.primaryColor,
                      ),
                    ],
                  ),

                  SpacingSize.spacingBaseHeight,

                  // using dropdown for class selection
                  Obx(() => DropdownInputWidget(
                      title: 'Pilih Kelas',
                      selected: controller.selectedItem.value,
                      items: controller.classItemList.toList(),
                      onChanged: (value) {
                        // do something
                        controller.selectedItem.value =
                            value ?? '(Pilih Kelas)';

                        if (value != null && value != '(Pilih Kelas)') {
                          final selectedId = controller.classMap[value];
                          log('Selected: $value, ID: $selectedId');
                          controller.selectedClassId = selectedId!;
                          controller.getDataPermissionByClass(
                              controller.selectedClassId.toString());
                        } else {
                          controller.selectedClassId = BigInt.from(-1);
                        }
                      },
                      hint: '(Pilih Kelas)')),

                  // list card of permissions
                  SpacingSize.spacingBaseHeight,
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      controller: controller.tabController,
                      indicatorColor: AppColor.primaryColor,
                      labelColor: AppColor.primaryColor,
                      tabs: const [
                        Tab(text: 'Diproses'),
                        Tab(text: 'Disetujui'),
                        Tab(text: 'Ditolak'),
                      ],
                    ),
                  ),

                  SpacingSize.spacingXSHeight,

                  Obx(() {
                    if (controller.isLoading.value) {
                      return Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (controller.filteredListPermission.isEmpty) {
                      return Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text('Data Kosong'),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.filteredListPermission.length,
                      itemBuilder: (context, index) {
                        final permission =
                            controller.filteredListPermission[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: CardPreviewPermissionStudent(
                            permissionData: permission,
                            onAccept: () {
                              controller.acceptPermission(
                                  context, permission.permission.id);
                            },
                            onReject: () {
                              // Fluttertoast.showToast(msg: 'Reject permission is not implemented yet');
                              controller.rejectPermission(
                                  context,
                                  permission.permission.id,
                                  'testing doang sih ini');
                            },
                          ),
                        );
                      },
                    );
                  }),

                  SpacingSize.spacingHugeHeight,
                ],
              ),
            )),
      ),
    );
  }

  void _showFilterBottomSheet(
      BuildContext context, TeacherPermissionController controller) {
    final startCtrl = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(controller.filterStartDate.value),
    );
    final endCtrl = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(controller.filterEndDate.value),
    );

    DateTime tempStart = controller.filterStartDate.value;
    DateTime tempEnd = controller.filterEndDate.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Perizinan',
                style: AppFontStyle.titleText.copyWith(fontSize: 16)),
            SpacingSize.spacingBaseHeight,
            DatepickerInputWithtitle(
              title: 'Pilih Tanggal Mulai',
              controller: startCtrl,
              hintTxt: 'Pilih tanggal mulai',
              lastDate: DateTime(DateTime.now().year + 5),
              initialDate: tempStart,
            ),
            SpacingSize.spacingBaseHeight,
            DatepickerInputWithtitle(
              title: 'Pilih Tanggal Selesai',
              controller: endCtrl,
              hintTxt: 'Pilih tanggal selesai',
              lastDate: DateTime(DateTime.now().year + 5),
              initialDate: tempEnd,
            ),
            SpacingSize.spacingLGHeight,
            ButtonPrimaryWidget(
              borderRadius: 20,
              title: 'Terapkan',
              callback: () {
                try {
                  final fmt = DateFormat('dd/MM/yyyy');
                  if (startCtrl.text.isNotEmpty) {
                    tempStart = fmt.parse(startCtrl.text);
                  }
                  if (endCtrl.text.isNotEmpty) {
                    tempEnd = fmt.parse(endCtrl.text);
                  }
                  controller.filterStartDate.value = tempStart;
                  controller.filterEndDate.value = tempEnd;
                  Navigator.pop(context);
                  if (controller.selectedClassId != BigInt.from(-1)) {
                    controller.getDataPermissionByClass(
                        controller.selectedClassId.toString());
                  }
                } catch (_) {}
              },
            ),
          ],
        ),
      ),
    );
  }
}
