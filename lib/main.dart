import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark),
  );

  runApp(const MyApp());
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
            debugShowCheckedModeBanner: false,
            title: 'Absensi QR Code',
            initialRoute: AppRoutes.initialRoute,
            getPages: AppRoutes.routes,
            themeMode: ThemeMode.light,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark),
              ),
            ),
          );
        },
      );
    });
  }
}
