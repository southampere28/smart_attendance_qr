import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:absensi_qr/configs/api_constant.dart';
import 'package:absensi_qr/domain/enum/announcement_type_enum.dart';
import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/models/response/api_result.dart';
import 'package:absensi_qr/models/user/student.dart';
import 'package:absensi_qr/models/user/teacher.dart';
import 'package:absensi_qr/models/user/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

part 'endpoint_service_auth_mixin.dart';
part 'endpoint_service_attendance_part.dart';
part 'endpoint_service_teacher_part.dart';

class EndpointService extends GetxService {
  // var for auth, method, etc...
  String? accessToken;
  String? tokenType;
  Map<String, dynamic>? userData;
  Student? studentData; // variabel global untuk data siswa yang login
  Teacher? teacherData; // variabel global untuk data guru yang login
  List<ClassModel>? classData;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<EndpointService> init() async {
    // load persisted tokens and user data from secure storage so service
    // can make authenticated requests after app restart
    try {
      accessToken = await _secureStorage.read(key: 'access_token');
      tokenType = await _secureStorage.read(key: 'token_type');

      final userJson = await _secureStorage.read(key: 'user');
      if (userJson != null) {
        userData = jsonDecode(userJson) as Map<String, dynamic>?;
      }

      if (userData != null) {
        if (userData!['role'] == 'student' && userData!['student'] != null) {
          studentData = Student.fromMap(userData!['student']);
        } else if (userData!['role'] == 'teacher' && userData!['teacher'] != null) {
          teacherData = Teacher.fromMap(userData!['teacher']);
        }
      }
    } catch (e) {
      log('EndpointService.init error: $e');
    }

    return this;
  }
}
