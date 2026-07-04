import 'package:absensi_qr/feature_student/attendance/presentation/attendance_binding.dart';
import 'package:absensi_qr/feature_student/attendance/presentation/attendance_page.dart';
import 'package:absensi_qr/feature_student/dashboard/presentation/dashboard_binding.dart';
import 'package:absensi_qr/feature_student/dashboard/presentation/dashboard_page.dart';
import 'package:absensi_qr/feature_student/form_permission/presentation/permission_form_binding.dart';
import 'package:absensi_qr/feature_student/form_permission/presentation/permission_form_page.dart';
import 'package:absensi_qr/feature_student/navigation/presentation/navigation_binding.dart';
import 'package:absensi_qr/feature_student/navigation/presentation/navigation_page.dart';
import 'package:absensi_qr/feature_student/notification/presentation/notification_student_binding.dart';
import 'package:absensi_qr/feature_student/notification/presentation/notification_student_page.dart';
import 'package:absensi_qr/feature_student/permission_detail/presentation/permission_detail_binding.dart';
import 'package:absensi_qr/feature_student/permission_detail/presentation/permission_detail_page.dart';
import 'package:absensi_qr/feature_student/schedule/presentation/schedule_binding.dart';
import 'package:absensi_qr/feature_student/schedule/presentation/schedule_page.dart';
import 'package:absensi_qr/feature_teacher/attendance_student/detail/presentation/detail_attendance_student_class_binding.dart';
import 'package:absensi_qr/feature_teacher/attendance_student/detail/presentation/detail_attendance_student_class_page.dart';
import 'package:absensi_qr/feature_teacher/attendance_student/primary/presentation/attendance_student_class_binding.dart';
import 'package:absensi_qr/feature_teacher/attendance_student/primary/presentation/attendance_student_class_page.dart';
import 'package:absensi_qr/feature_teacher/navigation/presentation/navigation_teacher_binding.dart';
import 'package:absensi_qr/feature_teacher/navigation/presentation/navigation_teacher_page.dart';
import 'package:absensi_qr/feature_teacher/permission/presentation/teacher_permission_binding.dart';
import 'package:absensi_qr/feature_teacher/permission/presentation/teacher_permission_page.dart';
import 'package:absensi_qr/feature_teacher/student_class/announcement/presentation/send_announcement_binding.dart';
import 'package:absensi_qr/feature_teacher/student_class/announcement/presentation/send_announcement_page.dart';
import 'package:absensi_qr/feature_teacher/dashboard/presentation/teacher_dashboard_binding.dart';
import 'package:absensi_qr/feature_teacher/dashboard/presentation/teacher_dashboard_page.dart';
import 'package:absensi_qr/feature_teacher/profile/presentation/profile_teacher_binding.dart';
import 'package:absensi_qr/feature_teacher/profile/presentation/profile_teacher_page.dart';
import 'package:absensi_qr/feature_teacher/shedule/schedule_class/presentation/schedule_class_binding.dart';
import 'package:absensi_qr/feature_teacher/shedule/schedule_class/presentation/schedule_class_page.dart';
import 'package:absensi_qr/feature_teacher/shedule/schedule_qr/presentation/schedule_qr_teacher_binding.dart';
import 'package:absensi_qr/feature_teacher/shedule/schedule_qr/presentation/schedule_qr_teacher_page.dart';
import 'package:absensi_qr/feature_teacher/shedule/schedule_teacher/presentation/schedule_teacher_binding.dart';
import 'package:absensi_qr/feature_teacher/shedule/schedule_teacher/presentation/schedule_teacher_page.dart';
import 'package:absensi_qr/feature_teacher/student_class/info_class/presentation/detail_information_class_binding.dart';
import 'package:absensi_qr/feature_teacher/student_class/info_class/presentation/detail_information_class_page.dart';
import 'package:absensi_qr/features/others/auth/login/presentation/login_binding.dart';
import 'package:absensi_qr/features/others/auth/login/presentation/login_page.dart';
import 'package:absensi_qr/features/others/auth/register_student/presentation/register_student_binding.dart';
import 'package:absensi_qr/features/others/auth/register_student/presentation/register_student_page.dart';
import 'package:absensi_qr/features/others/auth/register_teacher/presentation/register_teacher_binding.dart';
import 'package:absensi_qr/features/others/auth/register_teacher/presentation/register_teacher_page.dart';
import 'package:absensi_qr/features/others/choose_role/choose_role_binding.dart';
import 'package:absensi_qr/features/others/choose_role/choose_role_page.dart';
import 'package:absensi_qr/features/others/debug_config/debug_config_page.dart';
import 'package:absensi_qr/features/others/splash_screen/presentation/splash_screen_binding.dart';
import 'package:absensi_qr/features/others/splash_screen/presentation/splash_screen_page.dart';
import 'package:absensi_qr/feature_student/permission/presentation/permission_binding.dart';
import 'package:absensi_qr/feature_student/permission/presentation/permission_page.dart';
import 'package:absensi_qr/feature_student/profile/presentation/profile_binding.dart';
import 'package:absensi_qr/feature_student/profile/presentation/profile_page.dart';
import 'package:absensi_qr/feature_student/qr/presentation/qr_binding.dart';
import 'package:absensi_qr/feature_student/qr/presentation/qr_page.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class AppRoutes {
  // initialize
  static const initialRoute = splashScreen;

  // general
  static const login = '/login';
  static const chooserRoleUser = '/choose-role-user';
  static const registerStudent = '/register-student';
  static const registerTeacher = '/register-teacher';
  static const splashScreen = '/splash_screen';
  static const debugConfig = '/debug-config';
  // ==================

  // student
  static const navigation = '/navigation-student';
  static const dashboard = '/dashboard-student';
  static const notificationStudent = '/notification-student';
  static const schedule = '/schedule-student';
  static const attendance = '/attendance-student';
  static const permission = '/permission-student';
  static const permissionForm = '/permission-form-student';
  static const permissionDetail = '/permission-detail-student';
  static const profile = '/profile-student';
  static const qrscan = '/qrscan-student';
  // ==================

  // teacher
  static const navigationTeacher = '/navigation-teacher';
  static const dashboardTeacher = '/dashboard-teacher';
  static const scheduleQRTeacher = '/schedule-qr-teacher';
  static const scheduleTeacher = '/schedule-teacher';
  static const scheduleClass = '/schedule-class';
  static const detailInformationClass = '/detail-information-class';
  static const sendAnnouncement = '/send-announcement';
  static const permissionTeacher = '/permission-teacher';
  static const profileTeacher = '/profile-teacher';
  static const attendanceStudentClass = '/attendance-student-class';
  static const detailAttendanceStudentClass = '/detail-attendance-student-class';
  // activity of teacher: accept or reject permission, send announcement, submit report disrepancy student, etc.
  static const activityTeacher = '/activity-teacher';
  // ==================

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
      name: navigationTeacher,
      page: () => const NavigationTeacherPage(),
      binding: NavigationTeacherBinding(),
    ),
    GetPage(
      name: dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: notificationStudent,
      page: () => const NotificationStudentPage(),
      binding: NotificationStudentBinding(),
    ),
    GetPage(
      name: schedule,
      page: () => const SchedulePage(),
      binding: ScheduleBinding(),
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
      name: permissionForm,
      page: () => const PermissionFormPage(),
      binding: PermissionFormBinding(),
    ),
    GetPage(
      name: permissionDetail,
      page: () => const PermissionDetailPage(),
      binding: PermissionDetailBinding(),
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
      binding: LoginBinding(),
    ),
    GetPage(
      name: chooserRoleUser,
      page: () => const ChooseRolePage(),
      binding: ChooseRoleBinding(),
    ),
    GetPage(
      name: registerStudent,
      page: () => const RegisterStudentPage(),
      binding: RegisterStudentBinding(),
    ),
    GetPage(
      name: registerTeacher,
      page: () => const RegisterTeacherPage(),
      binding: RegisterTeacherBinding(),
    ),
    GetPage(
      name: dashboardTeacher,
      page: () => const TeacherDashboardPage(),
      binding: TeacherDashboardBinding(),
    ),
    GetPage(
      name: scheduleQRTeacher,
      page: () => const ScheduleQrTeacherPage(),
      binding: ScheduleQrTeacherBinding(),
    ),
    GetPage(
      name: scheduleTeacher,
      page: () => const ScheduleTeacherPage(),
      binding: ScheduleTeacherBinding(),
    ),
    GetPage(
      name: scheduleClass,
      page: () => const ScheduleClassPage(),
      binding: ScheduleClassBinding(),
    ),
    GetPage(
      name: detailInformationClass,
      page: () => const DetailInformationClassPage(),
      binding: DetailInformationClassBinding(),
    ),
    GetPage(
      name: sendAnnouncement,
      page: () => const SendAnnouncementPage(),
      binding: SendAnnouncementBinding(),
    ),
    GetPage(
      name: profileTeacher,
      page: () => const ProfileTeacherPage(),
      binding: ProfileTeacherBinding(),
    ),
    GetPage(
      name: permissionTeacher,
      page: () => const TeacherPermissionPage(),
      binding: TeacherPermissionBinding(),
    ),
    GetPage(
      name: attendanceStudentClass,
      page: () => const AttendanceStudentClassPage(),
      binding: AttendanceStudentClassBinding(),
    ),
    GetPage(
      name: detailAttendanceStudentClass,
      page: () => const DetailAttendanceStudentClassPage(),
      binding: DetailAttendanceStudentClassBinding(),
    ),


    // testing for ip address changing runtime
    if (kDebugMode)
      GetPage(
        name: debugConfig,
        page: () => const DebugConfigPage(),
      ),
  ];
}
