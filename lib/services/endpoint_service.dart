import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:absensi_qr/configs/api_constant.dart';
import 'package:absensi_qr/constant/app_config.dart';
import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/models/model_merging/attendance_report_item.dart';
import 'package:absensi_qr/models/model_merging/schedule_report_item.dart';
import 'package:absensi_qr/models/response/api_result.dart';
import 'package:absensi_qr/models/user/student.dart';
import 'package:absensi_qr/models/user/teacher.dart';
import 'package:absensi_qr/models/user/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class EndpointService extends GetxService {
  // var for auth, method, etc...
  String? accessToken;
  String? tokenType;
  Map<String, dynamic>? userData;
  Student? studentData; // variabel global untuk data siswa yang login
  Teacher? teacherData; // variabel global untuk data guru yang login

  // variabel kelas siswa
  List<ClassModel>? classData;

  // secure storage for tokens
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

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

  // attendance with qr request
  Future<ApiResult<Map<String, dynamic>>> qrAttendance({
    required String idStudent,
    required String idClass,
    required String qrcode,
    required String lat,
    required String lon,
  }) async {
    try {
      log(tokenType.toString());
      log(accessToken.toString());
      final response = await http.post(
        Uri.parse(ApiConstant.qrcodeAttendance),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken"
        },
        body: {
          "id_student": idStudent,
          "id_class": idClass,
          "qrcode": qrcode,
          "latitude": lat,
          "longitude": lon,
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

      if (status == 200 || status == 201) {
        final schedule = data["data"]["schedule"];
        final attendance = data["data"]["attendance"];

        log("Message: ${data["message"]}");
        log("Schedule: $schedule");
        log("Attendance: $attendance");

        return ApiResult(
          success: data["success"] ?? true,
          data: {
            "schedule": schedule,
            "attendance": attendance,
          },
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("QR Attendance error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
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

  // attendance by schedule class and date (for student personal attendance history)
  Future<ApiResult<List<Map<String, dynamic>>>> attendanceBySchedule({
    required String idClass,
    required String date, // format: YYYY-MM-DD
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstant.attendanceReport}?id_class=$idClass&date=$date'),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken"
        },
      );

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (status == 200) {
        final attendances = (data["data"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        log("Message: ${data["message"]}");
        log("Attendances: $attendances");

        return ApiResult(
          success: data["success"] ?? true,
          data: attendances,
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Attendance by schedule error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
          statusCode: status,
          errors: data['errors'] ?? "Failed to fetch attendance",
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

  // attendancec by schedule class and date (for all student in a class attendance report).
  Future<ApiResult<List<Map<String, dynamic>>>>
      attendanceReportByScheduleClass({
    required String idClass,
    required String date, // format: YYYY-MM-DD
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstant.attendanceReportClass}?id_class=$idClass&date=$date'),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken"
        },
      );

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (status == 200) {
        final attendances = (data["data"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        log("Message: ${data["message"]}");
        log("Attendances: $attendances");

        return ApiResult(
          success: data["success"] ?? true,
          data: attendances,
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Attendance report by schedule error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
          statusCode: status,
          errors: data['errors'] ?? "Failed to fetch attendance report",
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

  Future<ApiResult<List<Map<String, dynamic>>>> getAllSchedule({
    required String idClass,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstant.baseURL}/classes/$idClass/schedule'),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken"
        },
      );
      final status = response.statusCode;
      final data = jsonDecode(response.body);
      if (status == 200) {
        final schedules = (data["data"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        log("Message: ${data["message"]}");
        log("Schedules: $schedules");

        return ApiResult(
          success: data["success"] ?? true,
          data: schedules,
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("All schedules error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
          statusCode: status,
          errors: data['errors'] ?? "Failed to fetch schedules",
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

  Future<ApiResult<List<Map<String, dynamic>>>> getPermission({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final String startDateStr =
          '${startDate.year.toString().padLeft(4, '0')}-'
          '${startDate.month.toString().padLeft(2, '0')}-'
          '${startDate.day.toString().padLeft(2, '0')}';
      final String endDateStr = '${endDate.year.toString().padLeft(4, '0')}-'
          '${endDate.month.toString().padLeft(2, '0')}-'
          '${endDate.day.toString().padLeft(2, '0')}';

      final response = await http.get(
        Uri.parse(
            '${ApiConstant.studentPermissionReport}?start_date=$startDateStr&end_date=$endDateStr'),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken"
        },
      );

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (status == 200) {
        log("Message: ${data["message"]}");
        log("Permissions: ${data["data"]}");

        return ApiResult(
          success: data["success"] ?? true,
          data: data["data"] is List
              ? data["data"].cast<Map<String, dynamic>>()
              : [],
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Get permissions error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
          statusCode: status,
          errors: data['errors'] ?? "Failed to fetch permissions",
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

  Future<ApiResult<Map<String, dynamic>>> submitPermission({
    required String information,
    required String reason,
    required String datePermission, // format: YYYY-MM-DD
    required int dayCount, // time_period in days
    required String imagePath,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstant.baseURL}/attendance/permission'),
      );

      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = '$tokenType $accessToken';

      request.fields['information'] = information;
      request.fields['reason'] = reason;
      request.fields['date_permission'] = datePermission;
      request.fields['time_period'] = dayCount.toString();

      request.files
          .add(await http.MultipartFile.fromPath('evidence', imagePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (status == 200 || status == 201) {
        log("Message: ${data["message"]}");
        log("Permission: ${data["data"]}");

        return ApiResult(
          success: data["success"] ?? true,
          data: data["data"],
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Submit permission error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
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

  Future<ApiResult<Map<String, dynamic>>> attendanceReportDaily(
    DateTime date,
  ) async {
    try {
      // date parameter in format YYYY-MM-DD
      final String dateStr = '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';

      final response = await http.get(
        Uri.parse(
            '${ApiConstant.baseURL}/attendance-daily/report?date=$dateStr'),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken"
        },
      );

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (status == 200) {
        log("Message: ${data["message"]}");
        log("Daily report: ${data["data"]}");

        return ApiResult(
          success: data["success"] ?? true,
          data: data["data"],
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Daily report error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
          statusCode: status,
          errors: data['errors'] ?? "Failed to fetch daily report",
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

  Future<ApiResult<List<Map<String, dynamic>>>>
      teacherScheduleWeeklyPersonal() async {
    try {
      final response = await http.get(
          Uri.parse(ApiConstant.teacherScheduleWeeklyPersonal),
          headers: {
            "Accept": "application/json",
            "Authorization": "$tokenType $accessToken"
          });

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final schedules = (data["data"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        log("Message: ${data["message"]}");
        log("Schedules: $schedules");

        return ApiResult(
          success: data["success"] ?? true,
          data: schedules,
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Teacher schedule weekly personal error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
          statusCode: status,
          errors: data['errors'] ?? "Failed to fetch teacher schedule",
        );
      }

    } catch (e) {

      log('Exception: $e');
      return ApiResult(
        success: false,
        message: "Exception: $e",
        statusCode: null,
      );

    }
  }

  Future<ApiResult<List<Map<String, dynamic>>>> teacherSchedulePersonal() async {
    try {
      final response = await http.get(
          Uri.parse(ApiConstant.teacherSchedulePersonal),
          headers: {
            "Accept": "application/json",
            "Authorization": "$tokenType $accessToken"
          });

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final schedules = (data["data"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        log("Message: ${data["message"]}");
        log("Schedules: $schedules");

        return ApiResult(
          success: data["success"] ?? true,
          data: schedules,
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Teacher schedule personal error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
          statusCode: status,
          errors: data['errors'] ?? "Failed to fetch teacher schedule",
        );
      }

    } catch (e) {

      log('Exception: $e');
      return ApiResult(
        success: false,
        message: "Exception: $e",
        statusCode: null,
      );

    }
  }

  Future<ApiResult<List<Map<String, dynamic>>>> scheduleByClass(String classId) async {
    try {
      final response = await http.get(
          Uri.parse('${ApiConstant.teacherScheduleClass}/$classId'),
          headers: {
            "Accept": "application/json",
            "Authorization": "$tokenType $accessToken"
          });

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final schedules = (data["data"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        log("Message: ${data["message"]}");
        log("Schedules: $schedules");

        return ApiResult(
          success: data["success"] ?? true,
          data: schedules,
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Schedule by class error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
          statusCode: status,
          errors: data['errors'] ?? "Failed to fetch schedule by class",
        );
      }

    } catch (e) {

      log('Exception: $e');
      return ApiResult(
        success: false,
        message: "Exception: $e",
        statusCode: null,
      );

    }
  }

  Future<ApiResult<Map<String, dynamic>>> detailInformationClass(String classId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstant.detailInformationClass}/$classId'),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken"
      });

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        log("Message: ${data["message"]}");
        log("Class information: ${data["data"]}");
        return ApiResult(
          success: data["success"] ?? true,
          data: data["data"],
          message: data["message"],
          statusCode: status,
        );

      } else {
        log("Detail information class error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
          statusCode: status,
          errors: data['errors'] ?? "Failed to fetch class information",
        );
      }
      
    } catch (e) {
      log('Exception: $e');
      return ApiResult(
        success: false,
        message: "Exception: $e",
        statusCode: null,
      );
    }
  }

  // teacher only can access this endpoint to get all class they teach
  Future<ApiResult<List<Map<String, dynamic>>>> teacherClasses({
    required String classId, 
    required DateTime date
    }) async {
    try {
      // date parameter in format YYYY-MM-DD
      final String dateStr = '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';

      final response = await http.get(
        Uri.parse('${ApiConstant.reportStudentAttendanceByClass}/$classId/$dateStr'),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken"
        },
      );
      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (status == 200) {
        final classes = (data["data"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        log("Message: ${data["message"]}");
        log("Classes with Schedule attendance: $classes");

        return ApiResult(
          success: data["success"] ?? true,
          data: classes,
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Teacher classes error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
          statusCode: status,
          errors: data['errors'] ?? "Failed to fetch teacher classes",
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
    // load persisted tokens and user data from secure storage so service
    // can make authenticated requests after app restart
    // try {
    //   accessToken = await _secureStorage.read(key: 'access_token');
    //   tokenType = await _secureStorage.read(key: 'token_type');

    //   final userJson = await _secureStorage.read(key: 'user');
    //   if (userJson != null) {
    //     try {
    //       userData = jsonDecode(userJson) as Map<String, dynamic>?;
    //     } catch (e) {
    //       log('Failed to decode stored user JSON: $e');
    //       userData = null;
    //     }
    //   }

    //   if (userData != null) {
    //     if (userData!['role'] == 'student' && userData!['student'] != null) {
    //       try {
    //         studentData = Student.fromMap(userData!['student']);
    //       } catch (e) {
    //         log('Failed to parse studentData from stored user: $e');
    //       }
    //     } else if (userData!['role'] == 'teacher' && userData!['teacher'] != null) {
    //       try {
    //         teacherData = Teacher.fromMap(userData!['teacher']);
    //       } catch (e) {
    //         log('Failed to parse teacherData from stored user: $e');
    //       }
    //     }
    //   }
    // } catch (e) {
    //   log('EndpointService.init error: $e');
    // }

    return this;
  }
}
