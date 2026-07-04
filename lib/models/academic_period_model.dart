
// $table->string('name');
//             $table->dateTime('start_date');
//             $table->dateTime('end_date');

class AcademicPeriodModel {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  AcademicPeriodModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  factory AcademicPeriodModel.fromJson(Map<String, dynamic> json) {
    return AcademicPeriodModel(
      id: json['id'] as int,
      name: json['name'] as String,
      startDate: DateTime.parse(json['start_date'].toString()),
      endDate: DateTime.parse(json['end_date'].toString()),
    );
  }
}