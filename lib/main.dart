import 'dart:developer';
import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:absensi_qr/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  // service binding
  log("starting services ...");
  await Future.wait([
    Get.putAsync<EndpointService>(() async => await EndpointService().init()),
    Get.putAsync<GeolocationService>(() async => await GeolocationService().init()),
  ]);
  log("all services started ...");

  runApp(const MyApp());
}

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
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
