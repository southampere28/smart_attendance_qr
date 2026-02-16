import 'package:absensi_qr/models/user/user.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final EndpointService _httpService = Get.find<EndpointService>();

  final RxString name = ''.obs;
  final RxString nisn = ''.obs;
  final RxString email = ''.obs;
  final RxString className = ''.obs;
  final RxString major = ''.obs;
  final RxString entryYear = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (_httpService.studentData != null) {
      _setProfileData();
    } else {
      // fetchProfile();
    }
  }

  _setProfileData() {

    final String? emailService = _httpService.userData != null
      ? (_httpService.userData!['email'] as String?)
      : null;

    name.value = _httpService.studentData?.name ?? '';
    nisn.value = _httpService.studentData?.nisn ?? '';
    email.value = emailService ?? '';
    className.value = _httpService.studentData?.classData?.name ?? '';
    major.value = _httpService.studentData?.classData?.major ?? '';
    entryYear.value = _httpService.studentData != null
      ? _httpService.studentData!.entryYear.toString()
      : '';
  } 

}
