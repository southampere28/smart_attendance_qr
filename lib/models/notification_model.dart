// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:absensi_qr/core/helper/date_helper.dart';

class NotificationModel {
  final String title;
  final String body;
  final String? type;
  final String? sendTo;
  final int? senderId; // id user pengirim. bisa guru atau admin
  final int? receiverId; // id user penerima.
  final int? classId; // notifikasi untuk kelas.
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    required this.title,
    required this.body,
    this.type,
    this.sendTo,
    this.senderId,
    this.receiverId,
    this.classId,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'body': body,
      'type': type,
      'send_to': sendTo,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'class_id': classId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] as String,
      body: map['body'] as String,
      type: map['type'] != null ? map['type'] as String : null,
      sendTo: map['send_to'] != null ? map['send_to'] as String : null,
      senderId: map['sender_id'] != null ? map['sender_id'] as int : null,
      receiverId: map['receiver_id'] != null ? map['receiver_id'] as int : null,
      classId: map['class_id'] != null ? map['class_id'] as int : null,
      createdAt: map['created_at'] != null ? DateHelper.parseToLocal(map['created_at'].toString()) : DateTime.now(),
      updatedAt: map['updated_at'] != null ? DateHelper.parseToLocal(map['updated_at'].toString()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
