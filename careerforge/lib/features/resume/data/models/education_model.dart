import 'package:hive/hive.dart';

part 'education_model.g.dart';

@HiveType(typeId: 1)
class EducationModel extends HiveObject {
  @HiveField(0)
  String institution;

  @HiveField(1)
  String degree;

  @HiveField(2)
  String field;

  @HiveField(3)
  String startYear;

  @HiveField(4)
  String endYear;

  @HiveField(5)
  String grade;

  EducationModel({
    required this.institution,
    required this.degree,
    required this.field,
    required this.startYear,
    this.endYear = '',
    this.grade = '',
  });
}
