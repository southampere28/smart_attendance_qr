import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/helper/schedule_helper.dart';
import 'package:absensi_qr/core/widgets/shimmer_load_card.dart';
import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:absensi_qr/feature_student/dashboard/presentation/dashboard_controller.dart';
import 'package:absensi_qr/feature_student/dashboard/presentation/widgets/card_attendace_history.dart';
import 'package:absensi_qr/feature_student/dashboard/presentation/widgets/subject_preview_card.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.find<DashboardController>();

    return SizedBox(
      width: double.infinity,
      child: RefreshIndicator(
        onRefresh: () async {
          controller.getHistoryAttendance();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacingSize.spacingLGHeight,

                /// header section
                _headerSection(controller),

                SpacingSize.spacingBaseHeight,

                /// content section
                Obx(() {
                  if (controller.isLoadingAttendanceHistory.value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ShimmerLoadCard(
                        shimmerItemCount: 3,
                      ),
                    );
                  }

                  if (controller.attendanceHistoryResult.isEmpty) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text('Tidak ada riwayat absensi hari ini',
                          style: AppFontStyle.subTitleText),
                    );
                  }

                  // show list of attendance items
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: controller.attendanceHistoryResult.map((item) {
                      final formattedTimeStart = ScheduleHelper.convertTime2Pad(
                          item.schedule.startTime);
                      final formattedTimeEnd =
                          ScheduleHelper.convertTime2Pad(item.schedule.endTime);

                      return SubjectPreviewCard(
                        subjectName: item.schedule.subject?.name ??
                            'Nama Mata Pelajaran',
                        teacherName: item.schedule.teacher?.name ?? 'Nama Guru',
                        scheduleInfo:
                            "${item.schedule.dayOfWeek}, $formattedTimeStart - $formattedTimeEnd",
                        badgeInfo:
                            item.attendanceStatus == AttendanceStatusEnum.valid
                                ? 'valid'
                                : 'none',
                        isLive: false,
                      );
                    }).toList(),
                  );
                }),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ButtonPrimaryWidget(
                      borderRadius: 20,
                      title: "Lihat Semua Jadwal",
                      callback: () {
                        Get.toNamed(AppRoutes.schedule);
                      }),
                ),

                SpacingSize.spacingLGHeight,

                _attendanceDailiesSection(),

                SpacingSize.spacingLGHeight,

                _attendanceHistoriesSection(),

                /// testing only
                SizedBox(
                  height: 300,
                ),
                Text('Dashboard Page'),
                ElevatedButton(
                    onPressed: () {
                      controller.checkConnection();
                    },
                    child: Text('testconnection')),
                SizedBox(
                  height: 30,
                ),
                Obx(() => Text(
                      controller.placemark != ''
                          ? '${controller.placemarkVillage}, ${controller.placemarkLocality}, ${controller.placemarkCity}'
                          : 'Location: not fetched yet',
                      style: AppFontStyle.primaryText,
                    )),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () async {
                      // do something here
                      await controller.getLocation();
                    },
                    child: Text('Check Status Location'))
              ]),
        ),
      ),
    );
  }

  Widget _headerSection(DashboardController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// header section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Halo, Pramudya!', style: AppFontStyle.titleText),
                  SpacingSize.spacingXSHeight,
                  Text(
                    controller.dateNowFormatted,
                    style: AppFontStyle.subTitleText,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.notificationStudent);
                },
                child: Icon(
                  Icons.notifications,
                  color: Colors.black,
                  size: 34,
                ),
              ),
            ],
          ),
          SpacingSize.spacingXSHeight,
          Row(
            children: [
              Icon(
                Icons.location_pin,
                color: AppColor.primaryColor,
                size: 20,
              ),
              SpacingSize.spacingXSWidth,
              Expanded(child: Obx(() {
                return Text(
                    controller.placemarkVillage != 'No Data'
                        ? '${controller.placemarkStreet}, ${controller.placemarkVillage}'
                        : '-',
                    style: AppFontStyle.smallText
                        .copyWith(color: AppColor.primaryColor));
              }))
            ],
          ),
        ],
      ),
    );
  }

  Widget _attendanceDailiesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Absensi Harian',
              style: AppFontStyle.primaryText
                  .copyWith(fontWeight: FontWeight.bold)),
          SpacingSize.spacingSMHeight,
          Text('Absensi Harian Here...', style: AppFontStyle.subTitleText),
        ],
      ),
    );
  }

  Widget _attendanceHistoriesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Riwayat Absensi Hari Ini (30)',
              style: AppFontStyle.primaryText
                  .copyWith(fontWeight: FontWeight.bold)),
          SpacingSize.spacingSMHeight,
          CardAttendaceHistory(
            subjectTitle: "Bahasa Inggris",
            classTitle: "12 TKJ 2",
            attendanceRecords: [
              {'name': 'John Doe', 'status': 'Sudah Absen'},
              {'name': 'Jane Smith', 'status': 'Sudah Absen'}
            ],
          ),
        ],
      ),
    );
  }
}
