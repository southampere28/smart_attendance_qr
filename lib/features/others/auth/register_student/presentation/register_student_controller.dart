import 'dart:developer';

import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RegisterStudentController extends GetxController {
  final EndpointService endpointService = Get.find<EndpointService>();

  var isLoading = false.obs;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var nisnController = TextEditingController();
  var idClassController = TextEditingController();
  var entryYearController = TextEditingController();

  // variable texteditingcontroller name, email, pass, etc...

  // function to register
  Future<void> doRegister(BuildContext context, String name, String email,
      String password, String nisn, int idClass, int entryYear) async {
    isLoading.value = true;
    AppUtil.showLoadingDialog(context, message: "Register in process...");

    try {
      final result = await endpointService.registerStudent(
          name: name,
          email: email,
          password: password,
          nisn: nisn,
          idClass: idClass,
          entryYear: entryYear);

      isLoading.value = false;

      if (context.mounted) {
        AppUtil.hideLoadingDialog(context);
      }

      var msg = result.message ?? 'Register Fail!';

      if (result.success) {
        log("Token: ${endpointService.accessToken}");
        log("User info: ${endpointService.userData}");
        Get.toNamed(AppRoutes.login);
        Fluttertoast.showToast(msg: msg);
      } else {
        if (result.errors != null) {
          result.errors!.forEach((field, messages) {
            log("Field: $field, Messages: $messages");
            // bisa tampilkan toast per field
            Fluttertoast.showToast(msg: "${messages[0]}");
          });
        } else {
          Fluttertoast.showToast(msg: msg);
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppUtil.hideLoadingDialog(context);
      }
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'Error 500!');
      log('error while register : $e');
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    nisnController.dispose();
    idClassController.dispose();
    entryYearController.dispose();
    super.onClose();
  }
}
