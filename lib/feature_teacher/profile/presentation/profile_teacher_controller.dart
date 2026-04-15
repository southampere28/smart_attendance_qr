import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ProfileTeacherController extends GetxController {
  final EndpointService _httpService = Get.find<EndpointService>();

  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString subject = ''.obs;
  final RxString entryYear = ''.obs;
  final RxString nip = ''.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (_httpService.teacherData != null) {
      _setProfileData();
    } else {
      // fetchProfile();
      Fluttertoast.showToast(msg: 'data guru tidak ditemukan');
    }
  }

  _setProfileData() {
    final String? emailService = _httpService.userData != null
      ? (_httpService.userData!['email'] as String?)
      : null;

    name.value = _httpService.teacherData?.name ?? '';
    email.value = emailService ?? '';
    subject.value = _httpService.teacherData?.subject ?? '';
    nip.value = _httpService.teacherData?.nip ?? '';
  }


}