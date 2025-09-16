import 'dart:convert';
import 'dart:developer';

import 'package:absensi_qr/configs/api_constant.dart';
import 'package:absensi_qr/constant/app_config.dart';
import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/models/response/api_result.dart';
import 'package:absensi_qr/models/user/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class EndpointService extends GetxService {
  // var for auth, method, etc...
  String? accessToken;
  String? tokenType;
  Map<String, dynamic>? userData;

  // variabel kelas siswa
  List<ClassModel>? classData;

  Future<ApiResult> loadClasses() async {
    try {
      final response =
          await http.get(Uri.parse(ApiConstant.allClass)); // test akses koneksi
      final decoded = jsonDecode(response.body);
      final message = decoded['message'];
      final statusCode = response.statusCode;

      if (statusCode == 200 && decoded['success'] == true) {
        final classes = (decoded['data'] as List)
            .map((e) => ClassModel.fromMap(e))
            .toList();

        // simpan di variabel global biar bisa dipakai ulang
        classData = classes;

        for (var i = 0; i < classes.length; i++) {
          log('kelas global => ${classData![i]}');
        }
        return ApiResult(
            success: true,
            data: classes,
            message: message,
            statusCode: statusCode); // koneksi OK
      } else {
        Fluttertoast.showToast(msg: 'your API Failed to connect!');
        log('failed to connect!');
        return ApiResult(
            success: false,
            errors: decoded['errors'] ?? 'Failed to fetch classes',
            statusCode: statusCode); // server respon tapi status bukan 200
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'connect error!');
      log("Connection error: $e");
      return ApiResult(
          success: false,
          message: 'error : $e',
          statusCode: null); // gagal koneksi
    }
  }

  Future<bool> testConnection() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConstant.testConnection)); // test akses koneksi
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'your API Connected!');
        return true; // koneksi OK
      } else {
        Fluttertoast.showToast(msg: 'your API Failed to connect!');
        log('failed to connect!');
        return false; // server respon tapi status bukan 200
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'connect error!');
      log("Connection error: $e");
      return false; // gagal koneksi
    }
  }

  Future<ApiResult<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstant.loginURL),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "email": email,
          "password": password,
        },
      );

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Simpan token & user
        accessToken = data["access_token"];
        tokenType = data["token_type"];
        userData = data["user"];

        log("Token: $accessToken");
        log("User: ${userData.toString()}");

        return ApiResult(
          success: data["success"] ?? true,
          data: userData,
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Login error: ${response.body}");
        return ApiResult(
          success: false,
          message: data["message"],
          statusCode: status,
        );
      }
    } catch (e) {
      log("Exception: $e");
      return ApiResult(
        success: false,
        message: "Exception: $e",
        statusCode: null,
      );
    }
  }

  Future<ApiResult<Map<String, dynamic>>> registerStudent({
    required String name,
    required String email,
    required String password,
    required String nisn,
    required int idClass,
    required int entryYear,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstant.registerURL),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "name": name,
          "email": email,
          "password": password,
          "role": "student",
          "nisn": nisn,
          "id_class": idClass.toString(),
          "entry_year": entryYear.toString(),
        },
      );

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Simpan token & user
        accessToken = data["access_token"];
        tokenType = data["token_type"];
        userData = data["user"];

        log("Token: $accessToken");
        log("User: ${userData.toString()}");

        return ApiResult(
          success: data["success"] ?? true,
          data: userData,
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Register error: ${response.body}");
        return ApiResult(
          success: false,
          message: data["message"],
          statusCode: status,
          errors: data['errors'],
        );
      }
    } catch (e) {
      log("Exception: $e");
      return ApiResult(
        success: false,
        message: "Exception: $e",
        statusCode: null,
      );
    }
  }

  Future<ApiResult<Map<String, dynamic>>> registerTeacher({
    required String name,
    required String email,
    required String password,
    required String nip,
    required String subject,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstant.registerURL),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "name": name,
          "email": email,
          "password": password,
          "role": "teacher",
          "nip": nip,
          "subject": subject,
        },
      );

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Simpan token & user
        accessToken = data["access_token"];
        tokenType = data["token_type"];
        userData = data["user"];

        log("Token: $accessToken");
        log("User: ${userData.toString()}");

        return ApiResult(
          success: data["success"] ?? true,
          data: userData,
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Register error: ${response.body}");
        return ApiResult(
          success: false,
          message: data["message"],
          statusCode: status,
          errors: data['errors'],
        );
      }
    } catch (e) {
      log("Exception: $e");
      return ApiResult(
        success: false,
        message: "Exception: $e",
        statusCode: null,
      );
    }
  }

  Future<EndpointService> init() async {
    // inisialisasi token etc...
    await loadClasses();
    return this;
  }
}
