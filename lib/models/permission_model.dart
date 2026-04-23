import 'package:absensi_qr/core/helper/date_helper.dart';
import 'package:absensi_qr/domain/enum/permission_status_enum.dart';
import 'package:absensi_qr/domain/enum/permission_type_enum.dart';

class PermissionModel {
  final int id;
  final int? idStudent;
  final String information;
  final PermissionTypeEnum reason;
  final DateTime datePermission;
  final int dayCount;
  final String evidence;
  final PermissionStatusEnum status;
  final String feedback;
  final int? approvedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PermissionModel({
    required this.id,
    this.idStudent,
    required this.information,
    required this.reason,
    required this.datePermission,
    required this.dayCount,
    required this.evidence,
    required this.status,
    required this.feedback,
    this.approvedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory PermissionModel.fromMap(Map<String, dynamic> map) {
    return PermissionModel(
      id: map['id'] ?? 0,
      idStudent: map['id_student'] != null
          ? int.tryParse(map['id_student'].toString())
          : null,
      information: map['information'] ?? '',
      reason: PermissionTypeEnum.fromString(map['reason'] ?? ''),
      datePermission:
          DateHelper.parseToLocalNonNullable(map['date_permission']),
      dayCount: map['time_period'] != null
          ? int.tryParse(map['time_period'].toString()) ?? 0
          : 0,
      evidence: map['evidence'] ?? '',
      status: PermissionStatusEnum.fromString(map['status'] ?? ''),
      feedback: map['feedback'] ?? '',
      approvedBy: map['approved_by'] != null
          ? int.tryParse(map['approved_by'].toString())
          : null,
      createdAt: map['created_at'] != null
          ? DateHelper.parseToLocal(map['created_at'].toString())
          : null,
      updatedAt: map['updated_at'] != null
          ? DateHelper.parseToLocal(map['updated_at'].toString())
          : null,
    );
  }

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      PermissionModel.fromMap(json);

  Map<String, dynamic> toJson() {
    return toMap();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_student': idStudent,
      'information': information,
      'reason': reason.name,
      'date_permission': datePermission.toIso8601String(),
      'time_period': dayCount,
      'evidence': evidence,
      'status': status.name,
      'feedback': feedback,
      'approved_by': approvedBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
