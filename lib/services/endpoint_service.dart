import 'dart:convert';
import 'dart:developer';

import 'package:absensi_qr/configs/api_constant.dart';
import 'package:absensi_qr/constant/app_config.dart';
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

  Future<EndpointService> init() async {
    // inisialisasi token etc...
    return this;
  }
}
