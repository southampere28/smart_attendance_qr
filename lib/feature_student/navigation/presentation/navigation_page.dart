import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_student/navigation/presentation/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  Widget _buildNavItem({
    required NavigationController controller,
    required int index,
    IconData? icon,
    required String label,
  }) {
    final bool isActive = controller.currentIndex.value == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => index != -1 ? controller.changePage(index) : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isActive
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon != null
                      ? Icon(icon, color: AppColor.primaryColor)
                      : SizedBox
                          .shrink(), // Placeholder for spacing when no icon
                  Text(
                    label,
                    style: AppFontStyle.smallText
                        .copyWith(color: AppColor.primaryColor),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon != null
                      ? Icon(icon, color: AppColor.colorOutlineBoxinput)
                      : SizedBox(
                          height: 24,
                        ), // Placeholder for spacing when no icon
                  Text(
                    label,
                    style: AppFontStyle.smallText
                        .copyWith(color: AppColor.colorOutlineBoxinput),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.find<NavigationController>();

    return Scaffold(
      body: SafeArea(
        child: Obx(() => controller.pages[controller.currentIndex.value]),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const OvalBorder(),
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          final bool locationStatus = controller.getLocationStatus();
          if (locationStatus) {
            Get.toNamed(AppRoutes.qrscan);
          } else {
            Fluttertoast.showToast(msg: 'Mohon Nyalakan GPS Anda!');
          }
        },
        child: const Icon(
          Icons.qr_code_scanner_sharp,
          size: 30,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => SizedBox(
          height: 100,
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                ),
              ],
            ),
            child: BottomAppBar(
              color: Colors.white,
              shape: null,
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavItem(
                      controller: controller,
                      index: 0,
                      icon: Icons.home,
                      label: 'Home',
                    ),
                    _buildNavItem(
                      controller: controller,
                      index: 1,
                      icon: Icons.restore,
                      label: 'Presensi',
                    ),
                    _buildNavItem(
                        controller: controller,
                        index: -1,
                        icon: null,
                        label: 'Absen'),
                    // SpacingSize.spacingHugeWidth,
                    _buildNavItem(
                      controller: controller,
                      index: 2,
                      icon: Icons.event_note,
                      label: 'Perizinan',
                    ),
                    _buildNavItem(
                      controller: controller,
                      index: 3,
                      icon: Icons.person,
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
