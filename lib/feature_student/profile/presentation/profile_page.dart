import 'dart:async';

import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_student/profile/presentation/profile_controller.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final controller = Get.find<ProfileController>();
  late final StreamSubscription<bool> _loadingUpdateProfileSub;

  @override
  void initState() {
    super.initState();
    _loadingUpdateProfileSub =
        controller.isLoadingUpdateProfile.listen((isLoading) {
      if (isLoading) {
        AppUtil.showLoadingDialog(context, message: 'Mengunggah foto profil...');
      } else {
        try {
          AppUtil.hideLoadingDialog(context);
        } catch (_) {}
      }
    });
  }

  @override
  void dispose() {
    _loadingUpdateProfileSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpacingSize.spacingHugeHeight,
            Obx(() => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          controller.profileImageURL.value,
                          width: 100,
                          height: 100,
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
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: GestureDetector(
                        onTap: () {
                          controller.pickAndUploadProfilePicture();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                )),
            SpacingSize.spacingHugeHeight,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Informasi Akun',
                      style: AppFontStyle.titleText.copyWith(fontSize: 16)),
                  SpacingSize.spacingBaseHeight,
                  _profileInfoItem(
                      'Nama', controller.name.value, Icon(Icons.person)),
                  SpacingSize.spacingBaseHeight,
                  _profileInfoItem(
                      'NISN', controller.nisn.value, Icon(Icons.badge)),
                  SpacingSize.spacingBaseHeight,
                  _profileInfoItem(
                      'Kelas', controller.className.value, Icon(Icons.school)),
                  SpacingSize.spacingBaseHeight,
                  _profileInfoItem('Tahun Masuk', controller.entryYear.value,
                      Icon(Icons.calendar_today)),
                  SpacingSize.spacingBaseHeight,
                  ElevatedButton(
                    onPressed: () async {
                      // temporary only, logout and go to choose role page
                      await controller.logout(context);
                    },
                    child: Text('logout'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileInfoItem(String title, String value, Icon icon) {
    return Row(
      children: [
        Icon(icon.icon, color: AppColor.primaryColor, size: 20),
        SpacingSize.spacingBaseWidth,
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
