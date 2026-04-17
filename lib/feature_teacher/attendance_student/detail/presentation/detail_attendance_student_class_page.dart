import 'dart:math' as math;

import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/domain/enum/disrepancy_type_enum.dart';
import 'package:absensi_qr/feature_teacher/attendance_student/detail/presentation/detail_attendance_student_class_controller.dart';
import 'package:absensi_qr/models/attendance_history.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DetailAttendanceStudentClassPage extends StatelessWidget {
  const DetailAttendanceStudentClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailAttendanceStudentClassController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Absensi Kelas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacingSize.spacingBaseHeight,
              Text('Riwayat Absensi Kelas', style: AppFontStyle.titleText),
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

  Widget _listTileStudent(AttendanceHistory attendance,
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
            // GestureDetector(
            //     onTap: () {
            //       Fluttertoast.showToast(msg: 'testingg.');
            //     },
            //     child: Icon(Icons.menu, size: 20, color: Colors.black54)),
            IconButton(
                padding: EdgeInsets.all(4),
                onPressed: () {
                  // todo here...
                  Fluttertoast.showToast(msg: 'testingg.');
                  if (attendance.id != null) {
                    controller.submitDiscrepancyReport(
                      attendance.id!.toString(),
                      DisrepancyTypeEnum.hp_tidak_tersedia,
                      'Laporan ketidaksesuaian untuk ${attendance.student?.name ?? '(No Name)'}',
                    );
                  } else {
                    Fluttertoast.showToast(msg: 'ID absensi tidak tersedia');
                  }
                },
                constraints: const BoxConstraints(),
                icon: Icon(Icons.menu, size: 20, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
