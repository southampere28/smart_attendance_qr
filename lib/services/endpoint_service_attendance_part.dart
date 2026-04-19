part of 'endpoint_service.dart';

extension EndpointServiceAttendanceX on EndpointService {
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
  Future<ApiResult<List<Map<String, dynamic>>>> attendanceReportByScheduleClass({
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
        Uri.parse('${ApiConstant.baseURL}/attendance-daily/report?date=$dateStr'),
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

  // get notification for student side
  Future<ApiResult<List<Map<String, dynamic>>>> getStudentNotifications(String startDate, String endDate) async {
    try {
      // /api/student/notification?start_date=2026-04-10&end_date=2026-04-17
      final response = await http.get(
        Uri.parse('${ApiConstant.baseURL}/student/notifications?start_date=$startDate&end_date=$endDate'),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken"
        },
      );

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (status == 200) {
        log("Message: ${data["message"]}");
        log("Notifications: ${data["data"]}");

        return ApiResult(
          success: data["success"] ?? true,
          data: List<Map<String, dynamic>>.from(data["data"]),
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Student notifications error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
          statusCode: status,
          errors: data['errors'] ?? "Failed to fetch student notifications",
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
