import 'package:absensi_qr/features/others/splash_screen/presentation/splash_screen_binding.dart';
import 'package:absensi_qr/features/others/splash_screen/presentation/splash_screen_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const initialRoute = splashScreen;
  static const splashScreen = '/splash_screen';
  static const dashboard = '/dashboard';

  static final routes = <GetPage>[
    // Feature Others ----------------
    GetPage(
      name: splashScreen,
      page: () => const SplashScreenPage(),
      binding: SplashScreenBinding(),
    ),
    // GetPage(
    //   name: dashboard,
    //   page: () => const DashboardPage(),
    //   binding: DashboardBinding(),
    // ),
  ];
}
