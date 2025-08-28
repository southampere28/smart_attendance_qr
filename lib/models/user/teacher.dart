import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Teacher {
  final BigInt id;
  final String name;
  final String? nip;
  final String? subject;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  
  Teacher({
    required this.id,
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
      'name': name,
      'nip': nip,
      'subject': subject,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: BigInt.parse(map['id'].toString()),
      name: map['name'] as String,
      nip: map['nip'] != null ? map['nip'] as String : null,
      subject: map['subject'] != null ? map['subject'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'].toString()) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'].toString()) : null,
      deletedAt: map['deletedAt'] != null ? DateTime.parse(map['deletedAt'].toString()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Teacher.fromJson(String source) => Teacher.fromMap(json.decode(source) as Map<String, dynamic>);
}
