import 'dart:math' as math;
import 'dart:developer';

import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/helper/date_helper.dart';
import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:absensi_qr/domain/enum/disrepancy_type_enum.dart';
import 'package:absensi_qr/feature_teacher/attendance_student/detail/presentation/detail_attendance_student_class_controller.dart';
import 'package:absensi_qr/feature_teacher/attendance_student/detail/presentation/widgets/dialog_submit_disrepancy.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/models/attendance_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailAttendanceStudentClassPage extends StatelessWidget {
  const DetailAttendanceStudentClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailAttendanceStudentClassController>();

    final attendanceDate = controller.attendanceReport.dateAttendance;
    // formatted date of attendance
    final formattedDate = attendanceDate != null
        ? DateHelper.formatToDayDateMonthIndonesia(attendanceDate)
        : '(No Date)';
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Riwayat Absensi Kelas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacingSize.spacingBaseHeight,
              Row(
                children: [
                  SvgPicture.asset(
                    AssetConstant.svgIconSubject,
                    height: 16,
                    semanticsLabel: 'icon subject',
                  ),
                  SpacingSize.spacingXSWidth,
                  Expanded(
                    child: Text(
                      controller.attendanceReport.subject?.name ??
                          '(No Subject)',
                      style: AppFontStyle.subTitleText,
                    ),
                  ),
                  // tanggal
                  Text(
                    formattedDate,
                    style: AppFontStyle.subTitleText,
                  ),
                ],
              ),
              SpacingSize.spacingBaseHeight,
              Obx(() {
                if (controller.attendanceHistoryResult.isEmpty) {
                  return const Center(child: Text('Tidak ada data absensi'));
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DefaultTabController(
                    length: controller.attendanceStatusMenus.length,
                    child: Builder(builder: (context) {
                      final tabController = DefaultTabController.of(context);

                      List<AttendanceHistory> filterByMenu(String menu) {
                        return menu == 'Semua'
                            ? controller.attendanceHistoryResult
                            : controller.attendanceHistoryResult
                                .where((attendance) =>
                                    controller.attendanceStatusMenu[
                                        attendance.status] ==
                                    menu)
                                .toList();
                      }

                      const double rowHeight = 40.0; // matches itemExtent below
                      const double minHeight =
                          56.0; // keep a visible area when empty

                      return Column(
                        children: [
                          TabBar(
                            controller: tabController,
                            labelColor: Theme.of(context).primaryColor,
                            unselectedLabelColor: Colors.grey,
                            tabs: controller.attendanceStatusMenus
                                .map((menu) => Tab(text: menu))
                                .toList(),
                          ),
                          AnimatedBuilder(
                            animation: tabController.animation!,
                            builder: (context, _) {
                              final selectedMenu = controller
                                  .attendanceStatusMenus[tabController.index];
                              final selectedItems = filterByMenu(selectedMenu);
                              final tabHeight = math.max(
                                  selectedItems.length * rowHeight, minHeight);

                              return SizedBox(
                                height: tabHeight,
                                child: TabBarView(
                                  controller: tabController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: controller.attendanceStatusMenus
                                      .map((menu) {
                                    final filtered = filterByMenu(menu);
                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemExtent: rowHeight,
                                      itemCount: filtered.length,
                                      itemBuilder: (context, index) {
                                        final attendance = filtered[index];
                                        return _listTileStudent(
                                          context,
                                          attendance,
                                          controller,
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listTileStudent(BuildContext context, AttendanceHistory attendance,
      DetailAttendanceStudentClassController controller) {
    // color mapping for status
    Color getStatus() {
      switch (controller.attendanceStatusMenu[attendance.status]) {
        case 'Hadir':
          return AppColor.colorPresent;
        case 'Alpha':
          return AppColor.colorAlpha;
        case 'Izin':
          return AppColor.colorPermission;
        default:
          return Colors.grey;
      }
    }

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Icon(Icons.person, size: 20, color: getStatus()),
            SpacingSize.spacingSMWidth,
            Expanded(
              child: Text(
                attendance.student?.name ?? '(No Name)',
                style: AppFontStyle.primaryText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
                padding: EdgeInsets.all(4),
                onPressed: () {
                  if (attendance.status != AttendanceStatusEnum.valid) {
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                          vertical: 24.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Detail Siswa',
                                style: AppFontStyle.primaryText
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              SpacingSize.spacingLGHeight,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.person,
                                      size: 20, color: getStatus()),
                                  SpacingSize.spacingSMWidth,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          attendance.student?.name ??
                                              '(No Name)',
                                          style: AppFontStyle.primaryText
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Kelas : ${controller.attendanceReport.classModel?.name ?? '(No Class)'}',
                                          style: AppFontStyle.subTitleText,
                                        ),
                                        Row(
                                          children: [
                                            Text('Status: ',
                                                style:
                                                    AppFontStyle.subTitleText),
                                            Text(
                                              '${controller.attendanceStatusMenu[attendance.status]}',
                                              style: AppFontStyle.primaryText
                                                  .copyWith(color: getStatus()),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SpacingSize.spacingLGHeight,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ButtonPrimaryWidget(
                                    title: 'Batal',
                                    isMaxWidth: false,
                                    customColor: AppColor.colorAlpha,
                                    borderRadius: 50, // make it rounded
                                    isOutlineButton: true,
                                    customPadding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    callback: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),

                                  SpacingSize.spacingSMWidth,

                                  // show form dialog to submit discrepancy report
                                  // get back and call new Dialog to submit discrepancy report with type selection
                                  ButtonPrimaryWidget(
                                    title: 'Laporkan',
                                    isMaxWidth: false,
                                    borderRadius: 50, // make it rounded
                                    customColor: AppColor.colorAlpha,
                                    customPadding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    callback: () {
                                      if (attendance.id != null) {
                                        Navigator.of(context).pop();
                                        // open new dialog for submit discrepancy report
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DialogSubmitDisrepancy(
                                                controller: controller,
                                                idAttendance:
                                                    attendance.id!.toString(),
                                                studentName:
                                                    attendance.student?.name ??
                                                        '(No Name)',
                                                className: controller
                                                        .attendanceReport
                                                        .classModel
                                                        ?.name ??
                                                    '(No Class)',
                                                statusAttendance: controller
                                                            .attendanceStatusMenu[
                                                        attendance.status] ??
                                                    '(No Status)',
                                              );
                                            });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'ID absensi tidak tersedia');
                                      }
                                    },
                                  ),
                                  SpacingSize.spacingSMWidth,
                                ],
                              ),
                              // test redirect to maps coordinates based on attendance location
                              ButtonPrimaryWidget(
                                title: 'Lihat Lokasi',
                                isMaxWidth: false,
                                borderRadius: 50, // make it rounded
                                customColor: AppColor.colorAlpha,
                                customPadding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 5),
                                callback: () async {
                                  if (attendance.coordinates != null) {
                                    // coordinates : xxxxx,xxxxx
                                    final splittedLatLng = attendance
                                        .coordinates
                                        .toString()
                                        .split(',');
                                    if (splittedLatLng.length != 2) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Format data lokasi tidak valid');
                                      return;
                                    }

                                    final lat =
                                        double.tryParse(splittedLatLng[0]);
                                    final lng =
                                        double.tryParse(splittedLatLng[1]);

                                    if (lat == null || lng == null) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Format data lokasi tidak valid');
                                      return;
                                    }

                                    final googleMapsUrl =
                                        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

                                    // launch the url using url_launcher package
                                    try {
                                      final launched = await launchUrl(
                                        Uri.parse(googleMapsUrl),
                                        mode: LaunchMode.externalApplication,
                                      );
                                      if (!launched) {
                                        Fluttertoast.showToast(
                                            msg: 'Gagal membuka Google Maps');
                                      }
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                          msg: 'Error: ${e.toString()}');
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Data lokasi tidak tersedia untuk absensi ini');
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                constraints: const BoxConstraints(),
                icon: Icon(Icons.menu, size: 20, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
