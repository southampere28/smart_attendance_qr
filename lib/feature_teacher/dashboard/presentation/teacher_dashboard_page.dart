import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/widgets/shimmer_load_card.dart';
import 'package:absensi_qr/feature_teacher/dashboard/presentation/teacher_dashboard_controller.dart';
import 'package:absensi_qr/feature_teacher/dashboard/presentation/widgets/statistic_card_teacher.dart';
import 'package:absensi_qr/feature_teacher/dashboard/presentation/widgets/teacher_subject_preview_card.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TeacherDashboardPage extends StatelessWidget {
  const TeacherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    TeacherDashboardController controller =
        Get.find<TeacherDashboardController>();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColor.colorHeader,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _sectionHeader(controller),

                // teacher statistics student class.
                SpacingSize.spacingXLHeight,
                Obx(() {
                  if (controller.isLoadingStatistic.value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ShimmerLoadCard(
                        customHeight: 200,
                        shimmerItemCount: 1,
                      ),
                    );
                  } else {
                    if (controller.statiscticAttendanceToday.value == null) {
                      return Center(
                          child: Text('Tidak ada data statistik hari ini'));
                    }
                    return StatisticCardTeacher(
                        dataToday: controller.statiscticAttendanceToday.value!);
                  }
                }),

                SpacingSize.spacingXLHeight,
                _rowTextWidget(
                    title: 'Kelas Selanjutnya',
                    linkTitle: 'semua Jadwal',
                    onLinkTap: () {
                      // todo here...
                      Get.toNamed(AppRoutes.detailInformationClass);
                    }),

                // next class information.
                Obx(() {
                  if (controller.isLoading.value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ShimmerLoadCard(shimmerItemCount: 3),
                    );
                  } else if (controller.dataSchedule.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Tidak ada jadwal yang berlangsung / sudah lewat',
                          style: AppFontStyle.titleText,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.dataSchedule.length,
                      itemBuilder: (context, index) {
                        final item = controller.dataSchedule[index];
                        final startTime =
                            '${item.schedule.startTime.hour.toString().padLeft(2, '0')}:${item.schedule.startTime.minute.toString().padLeft(2, '0')}';
                        final endTime =
                            '${item.schedule.endTime.hour.toString().padLeft(2, '0')}:${item.schedule.endTime.minute.toString().padLeft(2, '0')}';
                        final scheduleInfo = '$startTime - $endTime';

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TeacherSchedulePreviewCard(
                              classTitle: item.classModel?.name ?? '-',
                              subjectName: item.subject?.name ?? '-',
                              scheduleInfo: scheduleInfo,
                              codeQR: item.schedule.code,
                              idSchedule: item.schedule.id,
                            ),
                            (controller.dataSchedule.length - 1) == index
                                ? SizedBox.shrink()
                                : SpacingSize.spacingSMHeight,
                          ],
                        );
                      },
                    );
                  }
                }),

                // button action see all classes
                SpacingSize.spacingLGHeight,

                ButtonPrimaryWidget(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    borderRadius: 20,
                    title: "Lihat Jadwal Anda",
                    callback: () {
                      Get.toNamed(AppRoutes.scheduleTeacher);
                    }),

                SpacingSize.spacingHugeHeight,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // section header
  Widget _sectionHeader(TeacherDashboardController controller) {
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
                child: Obx(() => CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColor.softColorPrimary,
                      child: ClipOval(
                        child: Image.network(
                          controller.profileImageURL.value,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            final String initials =
                                controller.name.value.isNotEmpty
                                    ? controller.name.value
                                        .trim()
                                        .split(' ')
                                        .map((e) => e[0])
                                        .take(2)
                                        .join()
                                    : '?';
                            return Text(
                              initials,
                              style: TextStyle(
                                color: AppColor.primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                    )),
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

  // row widget text for title and link action
  Widget _rowTextWidget({
    required String title,
    required String linkTitle,
    required VoidCallback onLinkTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppFontStyle.subTitleText),
          TextButton(
            onPressed: onLinkTap,
            child: Text(linkTitle,
                style: AppFontStyle.blueInfoText
                    .copyWith(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
