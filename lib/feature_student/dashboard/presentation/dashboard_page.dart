import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/helper/schedule_helper.dart';
import 'package:absensi_qr/core/widgets/card_attendance_daily_status.dart';
import 'package:absensi_qr/core/widgets/shimmer_load_card.dart';
import 'package:absensi_qr/domain/common/badges/attendance_status_badge.dart';
import 'package:absensi_qr/domain/enum/attendance_daily_status_enum.dart';
import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:absensi_qr/feature_student/dashboard/presentation/dashboard_controller.dart';
import 'package:absensi_qr/feature_student/dashboard/presentation/widgets/card_attendace_history.dart';
import 'package:absensi_qr/feature_student/dashboard/presentation/widgets/subject_preview_card.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/models/attendance_daily.dart';
import 'package:absensi_qr/models/attendance_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.find<DashboardController>();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColor.colorHeader,
        statusBarIconBrightness: Brightness.dark));

    return SizedBox(
      width: double.infinity,
      child: RefreshIndicator(
        onRefresh: () async {
          await controller.getHistoryAttendance();
          await controller.getAttendanceHistoryDaily();
          await controller.getHistoryAttendanceByClass();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// header section
                _sectionHeader(controller),

                SpacingSize.spacingBaseHeight,

                /// content section
                // weekend animation section
                Visibility(
                  visible: controller.isWeekend,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _weekendAnimationSection(),
                      SpacingSize.spacingLGHeight,
                    ],
                  ),
                ),

                // normal content if not weekend
                Visibility(
                    visible: !controller.isWeekend,
                    // visible: !controller.isWeekend,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() {
                          if (controller.isLoadingAttendanceHistory.value) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ShimmerLoadCard(
                                shimmerItemCount: 3,
                              ),
                            );
                          }

                          if (controller.attendanceHistoryResult.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: Text('Tidak ada riwayat absensi hari ini',
                                  style: AppFontStyle.subTitleText),
                            );
                          }

                          // show list of attendance items
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children:
                                controller.attendanceHistoryResult.map((item) {
                              final formattedTimeStart =
                                  ScheduleHelper.convertTime2Pad(
                                      item.schedule.startTime);
                              final formattedTimeEnd =
                                  ScheduleHelper.convertTime2Pad(
                                      item.schedule.endTime);

                              final resolvedStatusAttendance =
                                  item.attendance != null
                                      ? item.attendance!.status
                                      : AttendanceStatusEnum.none;

                              return SubjectPreviewCard(
                                subjectName: item.schedule.subject?.name ??
                                    'Nama Mata Pelajaran',
                                teacherName:
                                    item.schedule.teacher?.name ?? 'Nama Guru',
                                scheduleInfo:
                                    "${item.schedule.dayOfWeek}, $formattedTimeStart - $formattedTimeEnd",
                                badgeInfo: resolvedStatusAttendance.badge,
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
                        Obx(() {
                          if (controller.isLoadingAttendanceDaily.value) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ShimmerLoadCard(
                                shimmerItemCount: 1,
                              ),
                            );
                          }

                          return _attendanceDailiesSection(controller);
                        }),
                        SpacingSize.spacingLGHeight,
                        _attendanceHistoriesSection(controller),
                      ],
                    )),

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

  // section header
  Widget _sectionHeader(DashboardController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 20),
      decoration: BoxDecoration(
        color: AppColor.colorHeader,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.profileTeacher);
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.black,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
              SpacingSize.spacingSMWidth,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Text('Halo, ${controller.firstName.value}!',
                        style: AppFontStyle.titleText)),
                    Text(controller.dateNowFormatted,
                        style: AppFontStyle.subTitleText
                            .copyWith(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              Icon(
                Icons.notifications,
                color: AppColor.primaryColor,
                size: 30,
              ),
            ],
          ),
          SpacingSize.spacingBaseHeight,
          // location
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on,
                    size: 16, color: AppColor.primaryColor),
                SpacingSize.spacingSMWidth,
                Expanded(
                    child: Obx(() => Text(
                        controller.placemarkVillage != 'No Data'
                            ? '${controller.placemarkStreet}, ${controller.placemarkVillage}'
                            : '-',
                        style: AppFontStyle.blueInfoText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _attendanceDailiesSection(DashboardController controller) {
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
          CardAttendanceDailyStatus(
            attendance: controller.attendanceDailyResult.value,
          ),
        ],
      ),
    );
  }

  Widget _attendanceHistoriesSection(DashboardController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Riwayat Absensi Hari Ini',
                    style: AppFontStyle.primaryText
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              SpacingSize.spacingXSWidth,
              GestureDetector(
                  onTap: () => controller.getHistoryAttendanceByClass(),
                  child: Icon(Icons.replay,
                      size: 20, color: AppColor.primaryColor)),
              SpacingSize.spacingXSWidth,
            ],
          ),
          SpacingSize.spacingSMHeight,
          Obx(() {
            if (controller.isLoadingAttendanceByClassHistory.value) {
              return ShimmerLoadCard(
                shimmerItemCount: 3,
              );
            }

            if (controller.attendanceByClassHistoryResult.isEmpty) {
              return Text('Tidak ada riwayat absensi hari ini',
                  style: AppFontStyle.subTitleText);
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: controller.attendanceByClassHistoryResult.map((item) {
                final allowedAttendanceFilter = item.attendances
                    .where((attendanceItem) =>
                        attendanceItem.attendanceStatus ==
                            AttendanceStatusEnum.valid ||
                        attendanceItem.attendanceStatus ==
                            AttendanceStatusEnum.invalid ||
                        attendanceItem.attendanceStatus ==
                            AttendanceStatusEnum.permission ||
                        attendanceItem.attendanceStatus ==
                            AttendanceStatusEnum.sick ||
                        attendanceItem.attendanceStatus ==
                            AttendanceStatusEnum.dispensation)
                    .toList();

                return CardAttendaceHistory(
                  subjectTitle:
                      item.schedule.subject?.name ?? 'Nama Mata Pelajaran',
                  classTitle: item.schedule.classData?.name ?? 'Nama Kelas',
                  attendanceRecords: allowedAttendanceFilter,
                );
              }).toList(),
            );
          }),
          SpacingSize.spacingMDHeight,
        ],
      ),
    );
  }

  // section weekend animation
  Widget _weekendAnimationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SpacingSize.spacingLGHeight,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LottieBuilder.asset(
            'assets/animations/weekend.json',
            fit: BoxFit.contain,
          ),
        ),
        SpacingSize.spacingBaseHeight,
        Text('Yay! Hari ini libur akhir pekan 🎉',
            style:
                AppFontStyle.primaryText.copyWith(fontWeight: FontWeight.bold)),

        SpacingSize.spacingBaseHeight,
        // button lihat semua jadwal
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ButtonPrimaryWidget(
              borderRadius: 20,
              title: "Lihat Semua Jadwal",
              callback: () {
                Get.toNamed(AppRoutes.schedule);
              }),
        )
      ],
    );
  }
}
