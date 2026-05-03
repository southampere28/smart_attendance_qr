import 'dart:developer';

import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final EndpointService endpointService = Get.find();
  final MainController mainController = Get.find<MainController>();

  var isLoading = false.obs;
  var argument = ''.obs;
  var isPassObscure = true.obs;

  // variable controller textfield
  var emailController = TextEditingController();
  var passController = TextEditingController();

  Future<void> doLogin(
      BuildContext context, String email, String password) async {
    isLoading.value = true;
    AppUtil.showLoadingDialog(context, message: "Sedang login...");

    // validate email and password
    if (email.isEmpty || password.isEmpty) {
      isLoading.value = false;
      AppUtil.hideLoadingDialog(context);
      // Fluttertoast.showToast(msg: 'Email dan password tidak boleh kosong!');
      AppUtil.showGetSnackBar(
          'Login Gagal', 'Email dan password tidak boleh kosong!',
          isError: true);
      return;
    }

    // validate email using helper
    final emailError = AppUtil.validateEmail(email);
    if (emailError != null) {
      isLoading.value = false;
      AppUtil.hideLoadingDialog(context);
      AppUtil.showGetSnackBar('Login Gagal', emailError, isError: true);
      return;
    } else {
      // validate password using helper
      final passwordError = AppUtil.validatePassword(password);
      if (passwordError != null) {
        isLoading.value = false;
        AppUtil.hideLoadingDialog(context);
        AppUtil.showGetSnackBar('Login Gagal', passwordError, isError: true);
        return;
      }
    }

    try {
      final result = await endpointService.login(
        email: email,
        password: password,
      );

      isLoading.value = false;

      var msg = result.message ?? 'Login Fail!';

      if (result.success && result.data != null) {
        // get fcm token
        String? token = await FirebaseMessaging.instance.getToken();
        log("FCM Token: $token");

        final user = result.data!;
        log("Token: ${endpointService.accessToken}");
        log("User logged in: ${user.email} (${user.role})");

        // load academic period jika belum ada
        await _loadActiveAcademicPeriodIfEmpty();

        Fluttertoast.showToast(msg: msg);

        // Navigate based on role
        if (user.role == "teacher") {
          if (context.mounted) {
            AppUtil.hideLoadingDialog(context);
          }
          Get.toNamed(AppRoutes.navigationTeacher);
        } else if (user.role == "student") {
          mainController.userData.value = user;

          if (mainController.userData.value?.topicSubscribe != null) {
            final List<String> topics = [];

            // get topics from separated comma string
            final topicString = mainController.userData.value!.topicSubscribe!;
            topics.addAll(topicString.split(',').map((s) => s.trim()));

            // subscribe to multiple topics
            await mainController.subscribeToMultipleTopics(topics);
          }

          if (context.mounted) {
            AppUtil.hideLoadingDialog(context);
          }

          Get.toNamed(AppRoutes.navigation);
        } else {
          if (context.mounted) {
            AppUtil.hideLoadingDialog(context);
          }
          // Get.offAllNamed(AppRoutes.navigation);
        }
      } else {
        if (context.mounted) {
          AppUtil.hideLoadingDialog(context);
        }
        AppUtil.showGetSnackBar('Login Gagal', msg, isError: true);
      }
    } catch (e) {
      if (context.mounted) {
        AppUtil.hideLoadingDialog(context);
      }
      isLoading.value = false;
      AppUtil.showGetSnackBar('Login Gagal', 'Error!', isError: true);
      log('error while login : $e');
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Get role argument from navigation
    if (Get.arguments != null) {
      argument.value = Get.arguments;
      log('LoginController argument: ${argument.value}');

      // Pre-fill demo credentials (optional)
      if (argument.value == 'teacher') {
        log('Login as teacher');
        // emailController.text = 'teacher@demo.com';
      } else if (argument.value == 'student') {
        log('Login as student');
        // emailController.text = 'student@demo.com';
      }
    } else {
      log('No role argument provided');
    }
  }

  Future<void> _loadActiveAcademicPeriodIfEmpty() async {
    if (mainController.activeAcademicPeriod.value.isNotEmpty) return;

    try {
      final activePeriod = await endpointService.getActiveAcademicPeriod();
      if (activePeriod.success && activePeriod.data != null) {
        mainController.activeAcademicPeriod.value =
            activePeriod.data!['name'] ?? '';
        log('Academic period loaded on login: ${mainController.activeAcademicPeriod.value}');
      }
    } catch (e) {
      log('Failed to load academic period on login: $e');
    }
  }
}
