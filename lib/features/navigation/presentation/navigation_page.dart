import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/features/navigation/presentation/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationController controller = Get.find<NavigationController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat pagi Pramudya!'),
      ),
      body: Obx(() => controller.pages[controller.currentIndex.value]),
      floatingActionButton: FloatingActionButton(
        shape: OvalBorder(),
        backgroundColor: AppColor.infoColor,
        onPressed: () {
          Get.toNamed(AppRoutes.qrscan);
        },
        child: const Icon(
          Icons.qr_code,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() => SizedBox(
          height: 100,
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: Container(
              padding: const EdgeInsets.only(right: 2, left: 2, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(16), // biar rounded splash
                      onTap: () => controller.changePage(0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: controller.currentIndex.value == 0
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.home,
                                      color: AppColor.primaryColor),
                                  Text(
                                    'Home',
                                    style: AppFontStyle.smallText,
                                  ),
                                ],
                              )
                            : Icon(Icons.home,
                                color: AppColor.secondaryTextColor),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => controller.changePage(1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: controller.currentIndex.value == 1
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.assignment_turned_in,
                                      color: AppColor.primaryColor),
                                  Text(
                                    'Presensi',
                                    style: AppFontStyle.smallText,
                                  ),
                                ],
                              )
                            : Icon(Icons.assignment_turned_in,
                                color: AppColor.secondaryTextColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 60), // spacing FAB
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => controller.changePage(2),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: controller.currentIndex.value == 2
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.folder_copy,
                                        color: AppColor.primaryColor),
                                    Text(
                                      'Perizinan',
                                      style: AppFontStyle.smallText,
                                    ),
                                  ],
                                )
                              : Icon(Icons.folder_copy,
                                  color: AppColor.secondaryTextColor)),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => controller.changePage(3),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: controller.currentIndex.value == 3
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.person,
                                      color: AppColor.primaryColor),
                                  Text(
                                    'Profile',
                                    style: AppFontStyle.smallText,
                                  ),
                                ],
                              )
                            : Icon(Icons.person,
                                color: AppColor.secondaryTextColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))),
    );
  }
}
