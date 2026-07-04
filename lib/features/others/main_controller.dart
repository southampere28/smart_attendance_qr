import 'dart:async';
import 'dart:developer';

import 'package:absensi_qr/models/academic_period_model.dart';
import 'package:absensi_qr/models/user/student.dart';
import 'package:absensi_qr/models/user/teacher.dart';
import 'package:absensi_qr/models/user/user.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  // firebase messaging instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // academic periods active period
  final Rx<AcademicPeriodModel?> activeAcademicPeriod = Rx<AcademicPeriodModel?>(null);

  // data user and profile.
  final Rx<User?> userData = Rx<User?>(null);
  final Rx<Student?> studentData = Rx<Student?>(null);
  final Rx<Teacher?> teacherData = Rx<Teacher?>(null);

  // refresh trigger obx
  final RxInt refreshHomeStudent = 0.obs;
  final RxInt triggerUpdateProfile = 0.obs;

  final RxInt refreshPermission = 0.obs;
  final RxInt refreshHistory = 0.obs;

  // connectivity internet status check
  final RxList<ConnectivityResult> _connectionStatus =
      <ConnectivityResult>[ConnectivityResult.none].obs;
  final RxBool hasInternetConnection = true.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late StreamSubscription<InternetConnectionStatus> _internetConnectionSubscription;

  // service for notification
  // testing button for subscribe and unsubscribe to notifications
  Future<void> subscribeToNotifications(String topic) async {
    try {
      // ask permission on iOS/macOS; Android auto-grants
      await _firebaseMessaging.requestPermission();

      // ensure token exists (useful for debugging)
      await _firebaseMessaging.getToken();

      await _firebaseMessaging.subscribeToTopic(topic);
      log('Subscribed to $topic');
    } catch (e) {
      log('Subscribe failed: $e');
    }
  }

  // subscribe from list of topics
  Future<void> subscribeToMultipleTopics(List<String> topics) async {
    for (var topic in topics) {
      await subscribeToNotifications(topic);
    }
  }

  // unsubscribe from list of topics
  Future<void> unsubscribeFromMultipleTopics(List<String> topics) async {
    for (var topic in topics) {
      await unsubscribeFromNotifications(topic);
    }
  }

  // unsubscribe from notifications
  Future<void> unsubscribeFromNotifications(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      log('Unsubscribed from $topic');
    } catch (e) {
      log('Unsubscribe failed: $e');
    }
  }

  // logout student
  Future<void> logout() async {
    // clear all topic subscriptions (if needed)

    // get unsubscribe topic based on user data.
    List<String> userTopicSubscribe = [];

    if (userData.value?.topicSubscribe != null &&
        userData.value!.topicSubscribe != null &&
        userData.value!.topicSubscribe != '') {
      // split topics by comma and trim whitespace
      userTopicSubscribe = userData.value!.topicSubscribe!
          .split(',')
          .map((topic) => topic.trim())
          .toList();
    }

    // unsubscribe from all user topics
    await unsubscribeFromMultipleTopics(userTopicSubscribe);

    await Get.find<EndpointService>().clearAuthState();

    // clear user data
    userData.value = null;
    studentData.value = null;
    teacherData.value = null;

    // refresh token to invalidate old subscriptions
    await refreshToken();
  }

  // refresh token for resetting token when user logout
  Future<String> refreshToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      String? newToken = await _firebaseMessaging.getToken();
      return newToken ?? '';
    } catch (e) {
      log('Failed to refresh token: $e');
      return '';
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // initialize current connectivity
    initConnectivity();

    // listen to connectivity changes
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    // listen to internet connection changes
    _internetConnectionSubscription =
        InternetConnectionChecker().onStatusChange.listen(_updateInternetStatus);
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    _internetConnectionSubscription.cancel();
    super.onClose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log("Couldn't check connectivity status", error: e);
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List result) async {
    _connectionStatus.assignAll(result.cast<ConnectivityResult>());
  }

  // check actual internet connection (real connectivity test)
  Future<void> _updateInternetStatus(InternetConnectionStatus status) async {
    hasInternetConnection.value = (status == InternetConnectionStatus.connected);

    if (!hasInternetConnection.value) {
      AppUtil.showGetSnackBar(
        'Koneksi Terputus',
        'Tidak ada koneksi internet. Beberapa fitur mungkin tidak berfungsi.',
        isError: true,
      );
    } else {
      AppUtil.showGetSnackBar(
        'Koneksi Tersambung',
        'Koneksi internet tersedia.',
      );
    }
  }
}
