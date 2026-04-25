import 'dart:async';

import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_teacher/profile/presentation/profile_teacher_controller.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileTeacherPage extends StatefulWidget {
  const ProfileTeacherPage({super.key});

  @override
  State<ProfileTeacherPage> createState() => _ProfileTeacherPageState();
}

class _ProfileTeacherPageState extends State<ProfileTeacherPage> {
  final controller = Get.find<ProfileTeacherController>();
  late final StreamSubscription<bool> _loadingUpdateProfileSub;

  @override
  void initState() {
    super.initState();
    _loadingUpdateProfileSub = controller.isLoadingUpdateProfile.listen((isLoading) {
      if (!mounted) return;
      if (isLoading) {
        AppUtil.showLoadingDialog(context, message: 'Mengunggah foto profil...');
      } else {
        try { AppUtil.hideLoadingDialog(context); } catch (_) {}
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
    return Scaffold(
        body: Column(
      children: [
        Obx(() => _profileImage(controller.profileImageURL.value,
            controller.name.value, controller)),
        SpacingSize.spacingLGHeight,
        _profileInformation(controller),
      ],
    ));
  }

  Widget _profileImage(
      String imageURL, String name, ProfileTeacherController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.softColorPrimary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SpacingSize.spacingXXXLHeight,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Profil',
                style: AppFontStyle.titleText,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        SpacingSize.spacingLGHeight,
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.network(
                  imageURL,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    final String initials = name.isNotEmpty
                        ? name.trim().split(' ').map((e) => e[0]).take(2).join()
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
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
        SpacingSize.spacingXLHeight,
      ]),
    );
  }

  Widget _profileInformation(ProfileTeacherController controller) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
        children: [
          Text(
            'Informasi Akun',
            style: AppFontStyle.titleText.copyWith(fontSize: 16),
          ),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem('Nama', controller.name.value, Icon(Icons.person)),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem('NIP', controller.nip.value, Icon(Icons.badge)),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem('Email', controller.email.value, Icon(Icons.email)),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem(
              'Mata Pelajaran', controller.subject.value, Icon(Icons.school)),
          // SpacingSize.spacingBaseHeight,
          // _profileInfoItem('Tahun Masuk', '2020', Icon(Icons.calendar_today)),
        ],
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
