import 'dart:developer';

import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/models/user/user.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrController extends GetxController {
  late MobileScannerController scannerController;
  EndpointService apiService = Get.find<EndpointService>();

  // loading
  var isLoading = false.obs;

  // data schedule attendance
  var schedule = <String, dynamic>{}.obs;
  var attendance = <String, dynamic>{}.obs;

  // qr scan completed check
  final _isScanCompleted = false.obs;
  bool get isScanCompleted => _isScanCompleted.value;

  // method
  set isScanCompleted(bool value) {
    print('Status scan diubah dari ${_isScanCompleted.value} menjadi $value');
    _isScanCompleted.value = value;
  }

  // get user data
  User? get userData {
    var user = apiService.userData;

    if (user != null) {
      log(user.toString());
      return User.fromMap(user);
    } else {
      return null;
    }
  }

  Future<void> doQrAttendance({
    required String idStudent,
    required String idClass,
    required String qrcode,
  }) async {
    try {
      isLoading.value = true;

      final result = await apiService.qrAttendance(
        idStudent: idStudent,
        idClass: idClass,
        qrcode: qrcode,
      );

      if (result.success) {
        schedule.value = result.data?["schedule"] ?? {};
        attendance.value = result.data?["attendance"] ?? {};

        Get.offNamed(AppRoutes.navigation);
        log("Absensi sukses: Berhasil");
        Fluttertoast.showToast(msg: 'Absensi Berhasil!');
      } else {
        log("Absensi gagal: ${result.message}");
        if (result.statusCode != 500) {
          if (result.statusCode != null) {
            Fluttertoast.showToast(
                msg: result.message != null
                    ? 'gagal!, ${result.message}'
                    : 'Absensi Gagal');
            Get.back();
          } else {
            Fluttertoast.showToast(msg: 'gagal!, Periksa Jaringan Anda');
            Get.back();
          }
        } else {
          Fluttertoast.showToast(msg: 'Error Server 500!');
          log(result.message ?? 'Error Server 500');
        }
      }
    } catch (e) {
      log("Exception: $e");
      Fluttertoast.showToast(msg: 'Error Application 500!');
      log("Exception di controller: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    scannerController =
        MobileScannerController(facing: CameraFacing.back, torchEnabled: false);
  }
}
