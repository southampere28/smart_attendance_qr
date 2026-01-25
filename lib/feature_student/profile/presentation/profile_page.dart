import 'package:absensi_qr/app_routes.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpacingSize.spacingHugeHeight,
          Text('Profile Page'),
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
    );
  }
}
