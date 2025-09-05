import 'dart:convert';
import 'dart:developer';

import 'package:absensi_qr/configs/api_constant.dart';
import 'package:absensi_qr/constant/app_config.dart';
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

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstant.loginURL), // pastiin ada di ApiConstant
        headers: {
          "Accept": "application/json",
        },
        body: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Simpan token & user
        accessToken = data["access_token"];
        tokenType = data["token_type"];
        userData = data["user"];

        Fluttertoast.showToast(msg: 'Login success!');

        log("Token: $accessToken");
        log("User: ${userData.toString()}");

        return true;
      } else {
        Fluttertoast.showToast(msg: 'Login failed!');
        log("Login error: ${response.body}");
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Login error!');
      log("Exception: $e");
      return false;
    }
  }

  Future<EndpointService> init() async {
    // inisialisasi token etc...
    return this;
  }
}
