import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/helper/permission_helper.dart';
import 'package:absensi_qr/domain/enum/permission_status_enum.dart';
import 'package:absensi_qr/feature_student/permission/presentation/permission_controller.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/models/permission_model.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    PermissionController controller = Get.find<PermissionController>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
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
            // subtitle
            Text('Daftar perizinan yang telah dibuat',
                style: AppFontStyle.subTitleText),

            // using dummy date
            Text(
                'Menampilkan perizinan dari tanggal 8 Maret 2026 sampai 15 April 2026',
                style: AppFontStyle.subTitleText.copyWith(fontSize: 12)),

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
                  final permission = controller.filteredListPermission[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _cardPermissionContent(
                        context, permission, controller.nameOfStudent),
                  );
                },
              );
            }),

            Obx(() {
              return controller.statusSelected.value ==
                      PermissionStatusEnum.proses
                  ? ButtonPrimaryWidget(
                      borderRadius: 20,
                      title: "Buat",
                      callback: () {
                        Get.toNamed(AppRoutes.permissionForm);
                      })
                  : SizedBox.shrink();
            }),

            SpacingSize.spacingHugeHeight,

            ButtonPrimaryWidget(
                title: 'Test Get Data Permission',
                callback: () {
                  controller.getDataPermission();
                })
          ],
        ),
      )),
    );
  }

  Widget _cardPermissionContent(
    BuildContext context,
    PermissionModel permission,
    String nameOfStudent,
  ) {
    final datePermission = permission.datePermission;
    final formattedDate =
        PermissionHelper.formatDisplayPermissionInfo(datePermission);

    final reason = permission.reason.name;
    final status = permission.status.name;

    // mapping status to color
    final permissionStatusMap = {
      PermissionStatusEnum.diterima: Colors.green,
      PermissionStatusEnum.ditolak: Colors.red,
      PermissionStatusEnum.proses: Colors.orange,
    };

    return GestureDetector(
      onTap: () {
        // Handle tap event, e.g., navigate to detail page or show dialog
        AppUtil.showPermissionDetailDialogStudent(
          context,
          permissionData: permission,
          studentName: nameOfStudent,
          onTap: () {
            // handle to create new form permission.
            Get.toNamed(AppRoutes.permissionForm);
          },
        );
      },
      child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          // height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        reason,
                        style: AppFontStyle.primaryText
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SpacingSize.spacingXSHeight,
                      Text(
                        formattedDate,
                        style: AppFontStyle.subTitleText.copyWith(fontSize: 12),
                      ),
                    ],
                  )),
                  SpacingSize.spacingBaseWidth,
                  Text(
                    status,
                    style: AppFontStyle.subTitleText.copyWith(
                        color: permissionStatusMap[permission.status] ??
                            Colors.grey),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
