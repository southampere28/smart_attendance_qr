import 'package:absensi_qr/features/profile/presentation/profile_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.find<ProfileController>();

    return Center(
      child: Text('Profile Page'),
    );
  }
}
