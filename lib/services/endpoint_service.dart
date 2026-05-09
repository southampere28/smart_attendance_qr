import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

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
  User? userModel;
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
        userModel = User.fromMap(userData!);
        if (userData!['role'] == 'student' && userData!['student'] != null) {
          studentData = Student.fromMap(userData!['student']);
        } else if (userData!['role'] == 'teacher' &&
            userData!['teacher'] != null) {
          teacherData = Teacher.fromMap(userData!['teacher']);
        }
      }
    } catch (e) {
      log('EndpointService.init error: $e');
    }

    return this;
  }

  Future<void> clearAuthState() async {
    accessToken = null;
    tokenType = null;
    userData = null;
    userModel = null;
    studentData = null;
    teacherData = null;

    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'token_type');
    await _secureStorage.delete(key: 'user');
  }

  // general endpoint service methods.
  // get academic periods.
  Future<ApiResult<Map<String, dynamic>>> getActiveAcademicPeriod({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final url = Uri.parse('${ApiConstant.baseURL}/academic-periods/active');
    try {
      final response = await http
          .get(url, headers: {
            'Accept': 'application/json',
          })
          .timeout(timeout, onTimeout: () {
        throw TimeoutException('Request timed out after $timeout');
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        final data = result['data'] as Map<String, dynamic>;

        log('getActiveAcademicPeriod response: $data');
        return ApiResult(
          success: true,
          data: data,
        );
      } else {
        log('getActiveAcademicPeriod failed: ${response.statusCode} ${response.body}');
        return ApiResult(
            success: false, message: 'Failed to get active academic period');
      }
    } on TimeoutException catch (e) {
      log('getActiveAcademicPeriod timeout: $e');
      return ApiResult(
        success: false,
        message: 'Request timed out while fetching active academic period',
      );
    } catch (e) {
      log('getActiveAcademicPeriod error: $e');
      return ApiResult(
          success: false,
          message: 'Error occurred while fetching active academic period');
    }
  }

  // update profile picture.
  Future<ApiResult<Map<String, dynamic>>> updateProfilePicture({
    required File profilePicture,
  }) async {
    final url = Uri.parse('${ApiConstant.baseURL}/user/profile-picture');

    try {
      final request = http.MultipartRequest('POST', url)
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = '$tokenType $accessToken'
        ..files.add(await http.MultipartFile.fromPath('profile_picture', profilePicture.path));

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        final data = result['data'] as Map<String, dynamic>;

        log('updateProfilePicture response: $data');
        return ApiResult(
          success: true,
          data: data, // contains 'profile_picture' (filename) and 'profile_picture_url' (full URL)
        );
      } else {
        log('updateProfilePicture failed: ${response.statusCode} ${response.body}');
        return ApiResult(
            success: false, message: 'Failed to update profile picture');
      }
    } catch (e) {
      log('updateProfilePicture error: $e');
      return ApiResult(
          success: false,
          message: 'Error occurred while updating profile picture');
    }
  }

  Future<void> persistUserData() async {
    if (userData != null) {
      await _secureStorage.write(key: 'user', value: jsonEncode(userData));
    }
  }

  /// Update profile picture filename in both [userData] and [userModel],
  /// then persist to secure storage.
  Future<void> applyProfilePictureUpdate(String filename) async {
    if (userData != null) {
      userData!['profile_picture'] = filename;
      userModel = User.fromMap(userData!);
      await persistUserData();
    }
  }
}
