import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Teacher {
  final BigInt id;
  final BigInt idUser;
  final String name;
  final String? nip;
  final String? subject;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  
  Teacher({
    required this.id,
    required this.idUser,
    required this.name,
    this.nip,
    this.subject,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toString(),
      'id_user': idUser.toString(),
      'name': name,
      'nip': nip,
      'subject': subject,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: BigInt.parse(map['id'].toString()),
      idUser: BigInt.parse(map['id_user'].toString()),
      name: map['name'] as String,
      nip: map['nip'] != null ? map['nip'] as String : null,
      subject: map['subject'] != null ? map['subject'] as String : null,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'].toString()) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'].toString()) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at'].toString()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Teacher.fromJson(String source) => Teacher.fromMap(json.decode(source) as Map<String, dynamic>);
}
