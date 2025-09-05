import 'dart:developer';

import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final EndpointService endpointService = Get.find();

  var isLoading = false.obs;

  // variable controller textfield
  var emailController = TextEditingController();
  var passController = TextEditingController();

  Future<void> doLogin(String email, String password) async {
    isLoading.value = true;

    final success = await endpointService.login(
      email: email,
      password: password,
    );

    isLoading.value = false;

    if (success) {
      // Akses token / data user
      log("Token: ${endpointService.accessToken}");
      log("User email: ${endpointService.userData}");
      // TODO: navigate ke halaman utama
    } else {
      // TODO: tampilkan error di UI
    }
  }
}
