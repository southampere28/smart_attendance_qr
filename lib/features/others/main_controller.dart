import 'package:absensi_qr/models/user/student.dart';
import 'package:absensi_qr/models/user/teacher.dart';
import 'package:absensi_qr/models/user/user.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  
  // data user and profile.
  final Rx<Student?> userData = Rx<Student?>(null);
  final Rx<Student?> studentData = Rx<Student?>(null);
  final Rx<User?> teacherData = Rx<User?>(null);

  /// login (next use shared_preference and flutter_secure_storage)
  

}