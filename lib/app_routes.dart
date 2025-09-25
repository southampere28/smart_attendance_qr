import 'package:absensi_qr/features/attendance/presentation/attendance_binding.dart';
import 'package:absensi_qr/features/attendance/presentation/attendance_page.dart';
import 'package:absensi_qr/features/dashboard/presentation/dashboard_binding.dart';
import 'package:absensi_qr/features/dashboard/presentation/dashboard_page.dart';
import 'package:absensi_qr/features/navigation/presentation/navigation_binding.dart';
import 'package:absensi_qr/features/navigation/presentation/navigation_page.dart';
import 'package:absensi_qr/features/others/auth/login/presentation/login_binding.dart';
import 'package:absensi_qr/features/others/auth/login/presentation/login_page.dart';
import 'package:absensi_qr/features/others/auth/register_student/presentation/register_student_binding.dart';
import 'package:absensi_qr/features/others/auth/register_student/presentation/register_student_page.dart';
import 'package:absensi_qr/features/others/auth/register_teacher/presentation/register_teacher_binding.dart';
import 'package:absensi_qr/features/others/auth/register_teacher/presentation/register_teacher_page.dart';
import 'package:absensi_qr/features/others/splash_screen/presentation/splash_screen_binding.dart';
import 'package:absensi_qr/features/others/splash_screen/presentation/splash_screen_page.dart';
import 'package:absensi_qr/features/permission/presentation/permission_binding.dart';
import 'package:absensi_qr/features/permission/presentation/permission_page.dart';
import 'package:absensi_qr/features/profile/presentation/profile_binding.dart';
import 'package:absensi_qr/features/profile/presentation/profile_page.dart';
import 'package:absensi_qr/features/qr/presentation/qr_binding.dart';
import 'package:absensi_qr/features/qr/presentation/qr_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  // initialize
  static const initialRoute = navigation;
  
  // auth
  static const login = '/login';
  static const registerStudent = '/register-student';
  static const registerTeacher = '/register-teacher';
  
  // general
  static const navigation = '/navigation';
  static const splashScreen = '/splash_screen';
  static const dashboard = '/dashboard';
  static const attendance = '/attendance';
  static const permission = '/permission';
  static const profile = '/profile';
  static const qrscan = '/qrscan';

  static final routes = <GetPage>[
    // Feature Others ----------------
    GetPage(
      name: splashScreen,
      page: () => const SplashScreenPage(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: navigation,
      page: () => const NavigationPage(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: attendance,
      page: () => const AttendancePage(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: permission,
      page: () => const PermissionPage(),
      binding: PermissionBinding(),
    ),
    GetPage(
      name: profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
        name: qrscan,
        page: () => const QrPage(),
        binding: QrBinding(),
        transition: Transition.downToUp),
    GetPage(
        name: login,
        page: () => const LoginPage(),
        binding: LoginBinding(),),
    GetPage(
        name: registerStudent,
        page: () => const RegisterStudentPage(),
        binding: RegisterStudentBinding(),),
    GetPage(
        name: registerTeacher,
        page: () => const RegisterTeacherPage(),
        binding: RegisterTeacherBinding(),),
  ];
}
