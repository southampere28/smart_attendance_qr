part of 'endpoint_service.dart';

extension EndpointServiceAuthX on EndpointService {
  // load all student class (from grade 10 to 12)
  Future<ApiResult<List<ClassModel>>> loadClasses() async {
    try {
      final response = await http.get(Uri.parse(ApiConstant.allClass));

      // final response = await http.get(Uri.parse(ApiConstant.allClass)).timeout(
      //   Duration(seconds: 5),
      //   onTimeout: () {
      //     throw TimeoutException('timeout');
      //   },
      // );

      final decoded = jsonDecode(response.body);
      final message = decoded['message'];
      final statusCode = response.statusCode;

      if (statusCode == 200 && decoded['success'] == true) {
        final classes = (decoded['data'] as List)
            .map((e) => ClassModel.fromMap(e))
            .toList();

        // simpan di variabel global biar bisa dipakai ulang
        this.classData = classes;

        for (var i = 0; i < classes.length; i++) {
          log('kelas global => ${this.classData![i]}');
        }
        return ApiResult(
            success: true,
            data: classes,
            message: message,
            statusCode: statusCode); // koneksi OK
      } else {
        Fluttertoast.showToast(msg: 'Failed to connect!');
        log('koneksi ke server gagal!');
        return ApiResult(
            success: false,
            errors: decoded['errors'] ?? 'Failed to fetch classes',
            statusCode: statusCode); // server respon tapi status bukan 200
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'data gagal dimuat!');
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

  Future<void> storeFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;

      log("FCM Token: $token");

      await http.post(
        Uri.parse(ApiConstant.storeFcmTokenURL),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken",
        },
        body: {
          "fcm_token": token,
        },
      );
    } catch (e) {
      // jangan ganggu login
      log("Store FCM token error: $e");
    }
  }

  Future<ApiResult<User>> login({
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

        // guard empty token or user data
        if (accessToken == null || userData == null) {
          log("Login error: Missing access token or user data");
          return ApiResult(
            success: false,
            message: "Login failed: Missing access token or user data",
            statusCode: status,
          );
        }

        // persist securely
        await _secureStorage.write(key: 'access_token', value: accessToken);
        if (tokenType != null) {
          await _secureStorage.write(key: 'token_type', value: tokenType);
        }
        await _secureStorage.write(key: 'user', value: jsonEncode(userData));

        // convert to User entity
        if (userData!['role'] == 'student') {
          studentData = Student.fromMap(userData!['student']);
        } else if (userData!['role'] == 'teacher') {
          teacherData = Teacher.fromMap(userData!['teacher']);
        }

        final user = User.fromMap(userData!);

        log("Token: $accessToken");
        log("User: ${user.toString()}");
        log('student data global => ${studentData.toString()}');
        log('teacher data global => ${teacherData.toString()}');

        // store fcm token to server
        storeFcmToken();

        return ApiResult<User>(
          success: data["success"] ?? true,
          data: user,
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

  Future<ApiResult<User>> registerStudent({
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
      // .timeout(
      //   Duration(seconds: 30),
      //   onTimeout: () {
      //     throw TimeoutException('timeout');
      //   },
      // );

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Simpan token & user
        accessToken = data["access_token"];
        tokenType = data["token_type"];
        userData = data["user"];

        // persist securely
        await _secureStorage.write(key: 'access_token', value: accessToken);
        if (tokenType != null) {
          await _secureStorage.write(key: 'token_type', value: tokenType);
        }
        await _secureStorage.write(key: 'user', value: jsonEncode(userData));

        // convert to User entity
        final user = User.fromMap(userData!);

        log("Token: $accessToken");
        log("User: ${user.toString()}");

        return ApiResult<User>(
          success: data["success"] ?? true,
          data: user,
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

  Future<ApiResult<User>> registerTeacher({
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
      // .timeout(
      //   Duration(seconds: 30),
      //   onTimeout: () {
      //     throw TimeoutException('timeout');
      //   },
      // );

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Simpan token & user
        accessToken = data["access_token"];
        tokenType = data["token_type"];
        userData = data["user"];

        // persist securely
        await _secureStorage.write(key: 'access_token', value: accessToken);
        if (tokenType != null) {
          await _secureStorage.write(key: 'token_type', value: tokenType);
        }
        await _secureStorage.write(key: 'user', value: jsonEncode(userData));

        // convert to User entity
        final user = User.fromMap(userData!);

        log("Token: $accessToken");
        log("User: ${user.toString()}");

        return ApiResult<User>(
          success: data["success"] ?? true,
          data: user,
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
}
