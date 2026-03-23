import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_teacher/profile/presentation/profile_teacher_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileTeacherPage extends StatelessWidget {
  const ProfileTeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileTeacherController>();
    return Scaffold(
        body: Column(
      children: [
        _profileImage(),
        SpacingSize.spacingLGHeight,
        _profileInformation(),
      ],
    ));
  }

  Widget _profileImage() {
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
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60'),
        ),
        SpacingSize.spacingXLHeight,
      ]),
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
          Text(
            'Informasi Akun',
            style: AppFontStyle.primaryText
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem('Nama', 'Nur Hidayati', Icon(Icons.person)),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem('NIP', '123456789', Icon(Icons.badge)),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem(
              'Email', 'nur.hidayati@example.com', Icon(Icons.email)),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem('Mata Pelajaran', 'Sistem Digital, Matematika',
              Icon(Icons.school)),
          SpacingSize.spacingBaseHeight,
          _profileInfoItem('Tahun Masuk', '2020', Icon(Icons.calendar_today)),
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
