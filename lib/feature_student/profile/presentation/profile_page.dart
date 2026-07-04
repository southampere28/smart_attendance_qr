import 'dart:async';

import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_student/profile/presentation/profile_controller.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
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
      if (!mounted) return;
      if (isLoading) {
        AppUtil.showLoadingDialog(context,
            message: 'Mengunggah foto profil...');
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => _profileHeader(
                controller.profileImageURL.value, controller.name.value)),
            SpacingSize.spacingLGHeight,
            _profileInformation(),
            SpacingSize.spacingBaseHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buttonLogout('Keluar'),
            ),
            SpacingSize.spacingHugeHeight,
          ],
        ),
      ),
    );
  }

  Widget _buttonLogout(String title) {
    return Container(
      margin: EdgeInsets.zero,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
          onPressed: () async {
            final bool? confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Konfirmasi Keluar'),
                content: const Text('Apakah kamu yakin ingin keluar?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text(
                      'Keluar',
                      style: TextStyle(color: AppColor.colorAlpha),
                    ),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              controller.logout(context);
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), side: BorderSide.none),
            padding: const EdgeInsets.all(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: AppColor.colorAlpha, size: 20),
              SpacingSize.spacingSMWidth,
              Text(
                title,
                style: AppFontStyle.whiteBigText
                    .copyWith(color: AppColor.colorAlpha),
              ),
            ],
          )),
    );
  }

  Widget _profileHeader(String imageURL, String name) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.softColorPrimary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpacingSize.spacingXXXLHeight,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('Profil', style: AppFontStyle.titleText),
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
                          ? name
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
                  onTap: () => controller.pickAndUploadProfilePicture(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
          SpacingSize.spacingMDHeight,
          Text(name,
              style: AppFontStyle.primaryText
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
          SpacingSize.spacingXSHeight,
          Text('Siswa',
              style: AppFontStyle.subTitleText.copyWith(fontSize: 12)),
          SpacingSize.spacingMDHeight,
        ],
      ),
    );
  }

  Widget _profileInformation() {
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
          Text('Informasi Akun',
              style: AppFontStyle.titleText.copyWith(fontSize: 16)),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem(
              'Nama', controller.name.value, const Icon(Icons.person)),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem(
              'NISN', controller.nisn.value, const Icon(Icons.badge)),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem(
              'Email', controller.email.value, const Icon(Icons.email)),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem(
              'Kelas', controller.className.value, const Icon(Icons.school)),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem('Tahun Masuk', controller.entryYear.value,
              const Icon(Icons.calendar_today)),
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
              Text(title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
