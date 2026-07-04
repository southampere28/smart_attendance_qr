import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class PushNotificationService extends GetxService {
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'foreground_push_notifications',
    'Foreground Push Notifications',
    description: 'Notifications shown while the app is open',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _localNotificationsReady = false;

  Future<PushNotificationService> init() async {
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      try {
        const androidSettings =
            AndroidInitializationSettings('@mipmap/ic_launcher');
        const iosSettings = DarwinInitializationSettings();

        await _localNotifications.initialize(
          const InitializationSettings(
            android: androidSettings,
            iOS: iosSettings,
          ),
        );

        final androidImplementation =
            _localNotifications.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        await androidImplementation?.createNotificationChannel(_channel);
        await androidImplementation?.requestNotificationsPermission();
        _localNotificationsReady = true;
      } catch (e) {
        log('Local notifications init skipped: $e');
      }
    }

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('Notification opened from background: ${message.messageId}');
    });

    return this;
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;
    final title =
        notification?.title ?? data['title']?.toString() ?? 'Notifikasi';
    final body = notification?.body ?? data['body']?.toString() ?? '';

    if (title.isEmpty && body.isEmpty) {
      return;
    }

    if (!_localNotificationsReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.overlayContext == null && Get.context == null) return;
        Get.snackbar(
          title,
          body,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );
      });
      return;
    }

    await _localNotifications.show(
      notification.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.isNotEmpty ? message.data.toString() : null,
    );
  }
}
