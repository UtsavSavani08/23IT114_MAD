import 'package:hive/hive.dart';
import 'education_model.dart';
import 'experience_model.dart';

part 'resume_model.g.dart';

@HiveType(typeId: 0)
class ResumeModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String profileName;

  @HiveField(2)
  String fullName;

  @HiveField(3)
  String email;

  @HiveField(4)
  String phone;

  @HiveField(5)
  String address;

  @HiveField(6)
  String summary;

  @HiveField(7)
  List<String> skills;

  @HiveField(8)
  List<EducationModel> education;

  @HiveField(9)
  List<ExperienceModel> experience;

  @HiveField(10)
  DateTime createdAt;

  @HiveField(11)
  DateTime updatedAt;

  ResumeModel({
    required this.id,
    required this.profileName,
    required this.fullName,
    required this.email,
    required this.phone,
    this.address = '',
    this.summary = '',
    required this.skills,
    required this.education,
    required this.experience,
    required this.createdAt,
    required this.updatedAt,
  });

  ResumeModel copyWith({
    String? id,
    String? profileName,
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? summary,
    List<String>? skills,
    List<EducationModel>? education,
    List<ExperienceModel>? experience,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ResumeModel(
      id: id ?? this.id,
      profileName: profileName ?? this.profileName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      summary: summary ?? this.summary,
      skills: skills ?? List.from(this.skills),
      education: education ?? List.from(this.education),
      experience: experience ?? List.from(this.experience),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
