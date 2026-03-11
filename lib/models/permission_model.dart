import 'package:absensi_qr/core/helper/date_helper.dart';
import 'package:absensi_qr/domain/enum/permission_status_enum.dart';
import 'package:absensi_qr/domain/enum/permission_type_enum.dart';

class PermissionModel {
  final int id;
  final String information;
  final PermissionTypeEnum reason;
  final DateTime datePermission;
  final int dayCount;
  final String evidence;
  final PermissionStatusEnum status;
  final String feedback;

  PermissionModel({
    required this.id,
    required this.information,
    required this.reason,
    required this.datePermission,
    required this.dayCount,
    required this.evidence,
    required this.status,
    required this.feedback,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id'] ?? 0,
      information: json['information'] ?? '',
      reason: PermissionTypeEnum.fromString(json['reason'] ?? ''),
      datePermission: DateHelper.parseToLocalNonNullable(json['date_permission']),
      dayCount: json['time_period'] != null
          ? int.tryParse(json['time_period'].toString()) ?? 0
          : 0,
      evidence: json['evidence'] ?? '',
      status: PermissionStatusEnum.fromString(json['status'] ?? ''),
      feedback: json['feedback'] ?? '',
    );
  }
}
