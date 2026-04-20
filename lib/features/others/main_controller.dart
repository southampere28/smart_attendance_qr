import 'dart:developer';

import 'package:absensi_qr/models/user/student.dart';
import 'package:absensi_qr/models/user/teacher.dart';
import 'package:absensi_qr/models/user/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  
  // firebase messaging instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // academic periods active period
  final RxString activeAcademicPeriod = ''.obs;

  // data user and profile.
  final Rx<User?> userData = Rx<User?>(null);
  final Rx<Student?> studentData = Rx<Student?>(null);
  final Rx<Teacher?> teacherData = Rx<Teacher?>(null);

  // refresh trigger obx
  final RxInt refreshHomeStudent = 0.obs;


  /// login (next use shared_preference and flutter_secure_storage)
  
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

    if (userData.value?.topicSubscribe != null && userData.value!.topicSubscribe != null && userData.value!.topicSubscribe != '') {
      // split topics by comma and trim whitespace
      userTopicSubscribe = userData.value!.topicSubscribe!
          .split(',')
          .map((topic) => topic.trim())
          .toList();
    }

    // unsubscribe from all user topics
    await unsubscribeFromMultipleTopics(userTopicSubscribe);
    
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


}