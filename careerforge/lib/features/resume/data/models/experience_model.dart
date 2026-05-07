import 'package:hive/hive.dart';

part 'experience_model.g.dart';

@HiveType(typeId: 2)
class ExperienceModel extends HiveObject {
  @HiveField(0)
  String company;

  @HiveField(1)
  String role;

  @HiveField(2)
  String startDate;

  @HiveField(3)
  String endDate;

  @HiveField(4)
  String description;

  ExperienceModel({
    required this.company,
    required this.role,
    required this.startDate,
    this.endDate = '',
    this.description = '',
  });
}
