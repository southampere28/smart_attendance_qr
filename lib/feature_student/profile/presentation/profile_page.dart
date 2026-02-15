import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_student/profile/presentation/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.find<ProfileController>();

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpacingSize.spacingHugeHeight,
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60'),
            ),
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
                  _profileInfoItem('Nama', 'John Doe', Icon(Icons.person)),
                  SpacingSize.spacingBaseHeight,
                  _profileInfoItem('NISN', '1234567890', Icon(Icons.badge)),
                  SpacingSize.spacingBaseHeight,
                  _profileInfoItem('Kelas', 'XII RPL 1', Icon(Icons.school)),
                  SpacingSize.spacingBaseHeight,
                  _profileInfoItem(
                      'Tahun Masuk', '2024', Icon(Icons.calendar_today)),
                  SpacingSize.spacingBaseHeight,
                  ElevatedButton(
                    onPressed: () {
                      // temporary only, logout and go to choose role page
                      Get.offAllNamed(AppRoutes.chooserRoleUser);
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
