import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/helper/permission_helper.dart';
import 'package:absensi_qr/domain/enum/permission_status_enum.dart';
import 'package:absensi_qr/feature_student/permission/presentation/permission_controller.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/features/widgets/datepicker_input_withtitle.dart';
import 'package:absensi_qr/models/permission_model.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
        actions: [
          IconButton(
            onPressed: () => _showFilterBottomSheet(context, controller),
            icon: const Icon(Icons.tune),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getDataPermission();
        },
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // subtitle
                  Text('Daftar perizinan yang telah dibuat',
                      style: AppFontStyle.subTitleText),

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
                ],
              ),
            )),
      ),
    );
  }

  void _showFilterBottomSheet(
      BuildContext context, PermissionController controller) {
    // init TextEditingControllers with current filter values
    final startCtrl = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(controller.filterStartDate.value),
    );
    final endCtrl = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(controller.filterEndDate.value),
    );

    // local temp dates so we can cancel without affecting state
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
                // parse dari text controller (format dd/MM/yyyy)
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
                  controller.getDataPermission();
                } catch (_) {}
              },
            ),
            SpacingSize.spacingLGHeight,
          ],
        ),
      ),
    );
  }

  Widget _cardPermissionContent(
    BuildContext context,
    PermissionModel permission,
    String nameOfStudent,
  ) {
    final dateCreated = permission.createdAt ?? DateTime.now();
    final formattedDate =
        PermissionHelper.formatDisplayPermissionInfo(dateCreated);

    final reason = permission.reason.name;
    final status = permission.status.name;

    // mapping status to color
    final permissionStatusMap = {
      PermissionStatusEnum.diterima: Colors.green,
      PermissionStatusEnum.ditolak: Colors.red,
      PermissionStatusEnum.proses: Colors.orange,
    };

    // permission icon path
    final permissionIconPath = AssetConstant.getPermissionIconStatus(status);

    return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        // height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryColor.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  permissionIconPath,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.description,
                    size: 40,
                    color: AppColor.colorOutlineBoxinput,
                  ),
                ),
                SpacingSize.spacingSMWidth,
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
                    // tanggal perizinan dibuat.
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
            SpacingSize.spacingSMHeight,
            Divider(color: AppColor.colorOutlineBoxinput),
            SpacingSize.spacingXSHeight,
            GestureDetector(
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
              child: Row(
                children: [
                  Text(
                    'Lihat Detail Perizinan',
                    style: AppFontStyle.blueInfoText.copyWith(fontSize: 12),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppColor.primaryColor,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
