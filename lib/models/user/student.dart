import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Student {
  final BigInt id;
  final BigInt idClass;
  final String name;
  final String? nis;
  final int entryYear;
  final String? pictures;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  
  Student({
    required this.id,
    required this.idClass,
    required this.name,
    this.nis,
    required this.entryYear,
    this.pictures,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toString(),
      'idClass': idClass.toString(),
      'name': name,
      'nis': nis,
      'entryYear': entryYear,
      'pictures': pictures,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: BigInt.parse(map['id'].toString()),
      idClass: BigInt.parse(map['idClass'].toString()),
      name: map['name'] as String,
      nis: map['nis'] != null ? map['nis'] as String : null,
      entryYear: int.parse(map['entryYear'].toString()),
      pictures: map['pictures'] != null ? map['pictures'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'].toString()) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'].toString()) : null,
      deletedAt: map['deletedAt'] != null ? DateTime.parse(map['deletedAt'].toString()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) => Student.fromMap(json.decode(source) as Map<String, dynamic>);
}
