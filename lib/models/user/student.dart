import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Student {
  final BigInt id;
  final BigInt idUser;
  final BigInt idClass;
  final String name;
  final String? nisn;
  final int entryYear;
  final String? pictures;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  
  Student({
    required this.id,
    required this.idUser,
    required this.idClass,
    required this.name,
    this.nisn,
    required this.entryYear,
    this.pictures,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toString(),
      'id_user': idUser.toString(),
      'id_class': idClass.toString(),
      'name': name,
      'nisn': nisn,
      'entry_year': entryYear,
      'pictures': pictures,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: BigInt.parse(map['id'].toString()),
      idUser: BigInt.parse(map['id_user'].toString()),
      idClass: BigInt.parse(map['id_class'].toString()),
      name: map['name'] as String,
      nisn: map['nisn'] != null ? map['nisn'] as String : null,
      entryYear: int.parse(map['entry_year'].toString()),
      pictures: map['pictures'] != null ? map['pictures'] as String : null,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'].toString()) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'].toString()) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at'].toString()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) => Student.fromMap(json.decode(source) as Map<String, dynamic>);
}
