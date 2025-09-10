import 'dart:developer';

import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final EndpointService endpointService = Get.find();

  var isLoading = false.obs;

  // variable controller textfield
  var emailController = TextEditingController();
  var passController = TextEditingController();

  Future<void> doLogin(
      BuildContext context, String email, String password) async {
    isLoading.value = true;
    AppUtil.showLoadingDialog(context, message: "Sedang login...");

    try {
      final result = await endpointService.login(
        email: email,
        password: password,
      );

      isLoading.value = false;

      if (context.mounted) {
        AppUtil.hideLoadingDialog(context);
      }

      var msg = result.message ?? 'Login Fail!';

      if (result.success) {
        log("Token: ${endpointService.accessToken}");
        log("User email: ${endpointService.userData}");
        // Get.offNamed(AppRoutes.navigation);
        Get.toNamed(AppRoutes.navigation);
        Fluttertoast.showToast(msg: msg);
      } else {
        Fluttertoast.showToast(msg: msg);
      }
    } catch (e) {
      if (context.mounted) {
        AppUtil.hideLoadingDialog(context);
      }
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'Error!');
      log('error while login : $e');
    }
  }
}
