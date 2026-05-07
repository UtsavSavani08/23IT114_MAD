import 'package:hive/hive.dart';

// part 'application_model.g.dart';

@HiveType(typeId: 4)
enum ApplicationStatus {
  @HiveField(0)
  applied,
  @HiveField(1)
  shortlisted,
  @HiveField(2)
  interviewScheduled,
  @HiveField(3)
  rejected,
  @HiveField(4)
  selected,
}

@HiveType(typeId: 3)
class ApplicationModel extends HiveObject {
  @HiveField(0)
  String applicationId;

  @HiveField(1)
  String companyName;

  @HiveField(2)
  String jobRole;

  @HiveField(3)
  DateTime dateApplied;

  @HiveField(4)
  String resumeId;

  @HiveField(5)
  String resumeProfileName;

  @HiveField(6)
  ApplicationStatus status;

  @HiveField(7)
  String notes;

  @HiveField(8)
  String salaryExpectation;

  @HiveField(9)
  String jobUrl;

  @HiveField(10)
  DateTime lastUpdated;

  ApplicationModel({
    required this.applicationId,
    required this.companyName,
    required this.jobRole,
    required this.dateApplied,
    required this.resumeId,
    required this.resumeProfileName,
    required this.status,
    this.notes = '',
    this.salaryExpectation = '',
    this.jobUrl = '',
    required this.lastUpdated,
  });
}
