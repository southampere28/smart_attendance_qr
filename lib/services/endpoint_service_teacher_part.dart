part of 'endpoint_service.dart';

extension EndpointServiceTeacherX on EndpointService {
  Future<ApiResult<List<Map<String, dynamic>>>>
      teacherScheduleWeeklyPersonal() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConstant.teacherScheduleWeeklyPersonal), headers: {
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

  Future<ApiResult<List<Map<String, dynamic>>>>
      teacherSchedulePersonal() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConstant.teacherSchedulePersonal), headers: {
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

  Future<ApiResult<List<Map<String, dynamic>>>> scheduleByClass(
      String classId) async {
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

  Future<ApiResult<Map<String, dynamic>>> detailInformationClass(
      String classId) async {
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

  // teacher only can access this endpoint to get all attendance history of student in class by date.
  Future<ApiResult<List<Map<String, dynamic>>>> teacherClassesAttendance({
    required String classId,
    required DateTime date,
  }) async {
    try {
      // date parameter in format YYYY-MM-DD
      final String dateStr = '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';

      final response = await http.get(
        Uri.parse(
            '${ApiConstant.reportStudentAttendanceByClass}/$classId/$dateStr'),
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

  // get all classes attendance history daily for teacher by date and class id.
  Future<ApiResult<List<Map<String, dynamic>>>>
      fetchClassesAttendanceHistoryDaily(
          {required String classId, required String date // in format YYYY-MM-DD
          }) async {
    try {
      final response = await http.get(
        // /api/teacher/attendance/daily/class?id_class=1&date=2026-03-16
        Uri.parse(
            '${ApiConstant.reportStudentAttendanceDailyByClass}?id_class=$classId&date=$date'),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken"
        },
      );

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (status == 200 || status == 201) {
        final attendanceList = (data["data"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        return ApiResult(
          success: true,
          data: attendanceList,
          message: data["message"] ?? "Success",
          statusCode: status,
        );
      } else {
        return ApiResult(
          success: false,
          message: data["message"] ?? "Failed to fetch data",
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

  // send notification topic for teacher
  Future<ApiResult<Map<String, dynamic>>> sendAnnouncement({
    required String? title,
    required String message,
    required String idClass,
    required AnnouncementTypeEnum
        type, // "class_canceled", "assignment". (add later if needed)
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstant.sendAnnouncement),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken",
        },
        body: title != null
            ? {
                "title": title,
                "body": message,
                "class_id": idClass,
                "type": type.value,
              }
            : {
                "body": message,
                "class_id": idClass,
                "type": type.value,
              },
      );

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Announcement sent successfully: ${decoded["message"]}");
        return ApiResult(
          success: decoded["success"] ?? true,
          message: decoded["message"] ?? "Announcement sent successfully",
          data: decoded["data"] is Map<String, dynamic>
              ? decoded["data"] as Map<String, dynamic>
              : null,
          statusCode: response.statusCode,
        );
      } else {
        log("Failed to send announcement: ${response.body}");
        final rawErrors = decoded["errors"];
        return ApiResult(
          success: decoded["success"] ?? false,
          message: decoded["message"] ?? "Failed to send announcement",
          statusCode: response.statusCode,
          errors: rawErrors is Map<String, dynamic>
              ? rawErrors
              : {
                  "message":
                      rawErrors?.toString() ?? "Failed to send announcement"
                },
        );
      }
    } catch (e) {
      log("Exception while sending announcement: $e");
      return ApiResult(
        success: false,
        message: "Exception: $e",
        statusCode: null,
      );
    }
  }

  /// permission student feature zone

  // get permission by class.
  Future<ApiResult<List<Map<String, dynamic>>>> permissionByClass(
    String classId,
    String startDate, // in format YYYY-MM-DD
    String endDate, // in format YYYY-MM-DD
  ) async {
    try {
      final response = await http.get(
          Uri.parse(
              '${ApiConstant.permissionReportByClass}/$classId?start_date=$startDate&end_date=$endDate'),
          headers: {
            "Accept": "application/json",
            "Authorization": "$tokenType $accessToken"
          });

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final permissions = (data["data"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        log("Message: ${data["message"]}");
        log("Permissions: $permissions");

        return ApiResult(
          success: data["success"] ?? true,
          data: permissions,
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Permission by class error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
          statusCode: status,
          errors: data['errors'] ?? "Failed to fetch permissions by class",
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

  // accept permission by id permission (teacher only)
  Future<ApiResult<Map<String, dynamic>>> acceptPermission(
      String permissionId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstant.permissionAccept),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken"
        },
        body: {
          "permission_id": permissionId,
        },
      );
      final status = response.statusCode;
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        log("Permission accepted successfully: ${data["message"]}");
        return ApiResult(
          success: data["success"] ?? true,
          message: data["message"] ?? "Permission accepted successfully",
          data: data["data"] is Map<String, dynamic>
              ? data["data"] as Map<String, dynamic>
              : null,
          statusCode: status,
        );
      } else {
        log("Failed to accept permission: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Failed to accept permission",
          statusCode: status,
          errors: data['errors'] ?? "Failed to accept permission",
        );
      }
    } catch (e) {
      log("Exception while accepting permission: $e");
      return ApiResult(
        success: false,
        message: "Exception: $e",
        statusCode: null,
      );
    }
  }

  // reject permission by id permission (teacher only)
  Future<ApiResult<Map<String, dynamic>>> rejectPermission(
      String permissionId, String reasonReject) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstant.permissionReject),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken",
        },
        body: {
          "permission_id": permissionId,
          "feedback": reasonReject,
        },
      );
      final status = response.statusCode;
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        log("Permission rejected successfully: ${data["message"]}");
        return ApiResult(
          success: data["success"] ?? true,
          message: data["message"] ?? "Permission rejected successfully",
          data: data["data"] is Map<String, dynamic>
              ? data["data"] as Map<String, dynamic>
              : null,
          statusCode: status,
        );
      } else {
        log("Failed to reject permission: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Failed to reject permission",
          statusCode: status,
          errors: data['errors'] ?? "Failed to reject permission",
        );
      }
    } catch (e) {
      log("Exception while rejecting permission: $e");
      return ApiResult(
        success: false,
        message: "Exception: $e",
        statusCode: null,
      );
    }
  }

  /// permission student feature zone END

  /// disrepancy report feature zone (teacher only)
  Future<ApiResult<Map<String, dynamic>>> submitDiscrepancyReport({
    required String attendanceHistoryId,
    required String disrepancyType,
    required String reason,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstant.discrepancyReport),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken",
        },
        body: {
          "attendance_history_id": attendanceHistoryId,
          "disrepancy_type": disrepancyType,
          "description": reason,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        log("Discrepancy report submitted successfully: ${data["message"]}");
        return ApiResult(
          success: data["success"] ?? true,
          message:
              data["message"] ?? "Discrepancy report submitted successfully",
          data: data["data"] is Map<String, dynamic>
              ? data["data"] as Map<String, dynamic>
              : null,
          statusCode: response.statusCode,
        );
      } else {
        log("Failed to submit discrepancy report: ${response.body}");
        final data = jsonDecode(response.body);
        final rawErrors = data["errors"];
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Failed to submit discrepancy report",
          statusCode: response.statusCode,
          errors: rawErrors is Map<String, dynamic>
              ? rawErrors
              : {
                  "message": rawErrors?.toString() ??
                      "Failed to submit discrepancy report"
                },
        );
      }
    } catch (e) {
      log("Exception while submitting discrepancy report: $e");
      return ApiResult(
        success: false,
        message: "Exception: $e",
        statusCode: null,
      );
    }
  }

  /// disrepancy report feature zone END

  // get all activity from teacher here.
  Future<ApiResult<List<Map<String, dynamic>>>> getTeacherActivity({
    required String startDate, // in format YYYY-MM-DD
    required String endDate, // in format YYYY-MM-DD
  }) async {
    try {
      final response = await http.get(
        // {{wifirumah}}/api/teacher/activity?start_date=2026-04-1&end_date=2026-04-23
        Uri.parse(
            '${ApiConstant.teacherActivity}?start_date=$startDate&end_date=$endDate'),
        headers: {
          "Accept": "application/json",
          "Authorization": "$tokenType $accessToken",
        },
      );

      final status = response.statusCode;
      final data = jsonDecode(response.body);

      if (status == 200) {
        final activities = (data["data"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        log("Message: ${data["message"]}");
        log("Activities: $activities");

        return ApiResult(
          success: data["success"] ?? true,
          data: activities,
          message: data["message"],
          statusCode: status,
        );
      } else {
        log("Get teacher activity error: ${response.body}");
        return ApiResult(
          success: data["success"] ?? false,
          message: data["message"] ?? "Something went wrong",
          statusCode: status,
          errors: data['errors'] ?? "Failed to fetch teacher activity",
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
}
