import 'dart:developer';

import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/models/user/user.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrController extends GetxController {
  late MobileScannerController scannerController;
  EndpointService apiService = Get.find<EndpointService>();
  GeolocationService _geoService = Get.find<GeolocationService>();

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

  Future<void> startScan({
    required BuildContext context,
    required String idStudent,
    required String idClass,
    required String qrcode,
  }) async {
    try {
      if ((_geoService.lattitude != '') && (_geoService.longitude != '')) {
        await doQrAttendance(
            idStudent: idStudent,
            idClass: idClass,
            qrcode: qrcode,
            context: context);
      } else {
        Fluttertoast.showToast(msg: 'mencoba mendapatkan lokasi');
        var getLocation = await _geoService.getCurrentPosition(30);

        if (getLocation) {
          await doQrAttendance(
            // ignore: use_build_context_synchronously
            context: context,
            idStudent: idStudent,
            idClass: idClass,
            qrcode: qrcode,
          );
        } else {
          Get.back();
        }
      }
    } catch (e, st) {
      log("Error saat startScan: $e");
      log("$st");
    } finally {
      if (context.mounted) {
        AppUtil.hideLoadingDialog(context);
      }
    }
  }

  Future<void> doQrAttendance({
    required BuildContext context,
    required String idStudent,
    required String idClass,
    required String qrcode,
  }) async {
    try {
      isLoading.value = true;

      AppUtil.showLoadingDialog(context,
          message: 'Permintaan sedang diproses...');

      final result = await apiService.qrAttendance(
        idStudent: idStudent,
        idClass: idClass,
        qrcode: qrcode,
        lat: _geoService.lattitude ?? '0',
        lon: _geoService.longitude ?? '0',
      );

      if (context.mounted) {
        AppUtil.hideLoadingDialog(context);
      }

      if (result.success) {
        schedule.value = result.data?["schedule"] ?? {};
        attendance.value = result.data?["attendance"] ?? {};

        log("Absensi sukses: Berhasil");
        Fluttertoast.showToast(msg: 'Absensi Berhasil!');
        Get.offNamed(AppRoutes.navigation);
      } else {
        log("Absensi gagal: ${result.message}");
        if (result.statusCode != 500) {
          if (result.statusCode != null) {
            Fluttertoast.showToast(
                msg: result.message != null
                    ? 'gagal!, ${result.message}'
                    : 'Absensi Gagal');
            Get.offNamed(AppRoutes.navigation);
          } else {
            Fluttertoast.showToast(msg: 'gagal!, Periksa Jaringan Anda');
            Get.offNamed(AppRoutes.navigation);
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
