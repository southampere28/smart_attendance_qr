import 'dart:developer';
import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/configs/api_constant.dart';
import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:absensi_qr/services/push_notification_service.dart';
import 'package:absensi_qr/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  log("initializing firebase ...");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log("initializing firebase completed");

  await initializeDateFormatting('id_ID', null);

  // load persisted base URL override for debugging
  await ApiConstant.loadBaseUrl();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  // service binding
  log("starting services ...");
  await Future.wait([
    Get.putAsync<EndpointService>(() async => await EndpointService().init()),
    Get.putAsync<GeolocationService>(
        () async => await GeolocationService().init()),
    Get.putAsync<PushNotificationService>(
      () async => await PushNotificationService().init()),
  ]);
  log("all services started ...");

  runApp(const MyApp());
}

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;

      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppSize.init(
              context,
              containerWidth: maxWidth,
              containerHeight: maxHeight,
            );
          });

          return GetMaterialApp(
            locale: const Locale('id', 'ID'),
            supportedLocales: const [
              Locale('id', 'ID'),
              Locale('en', 'US'),
              Locale('en', 'GB')
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialBinding: MainBinding(),
            debugShowCheckedModeBanner: false,
            title: 'Absensi QR Code',
            initialRoute: AppRoutes.initialRoute,
            getPages: AppRoutes.routes,
            themeMode: ThemeMode.system,
          );
        },
      );
    });
  }
}
