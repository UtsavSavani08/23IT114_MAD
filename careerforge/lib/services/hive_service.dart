// ignore_for_file: unused_field
import 'package:hive_flutter/hive_flutter.dart';
// import '../features/resume/data/models/resume_model.dart';
// import '../features/application/data/models/application_model.dart';

class HiveService {
  static const String _resumesBoxName = 'resumes';
  static const String _applicationsBoxName = 'applications';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // TODO: Register adapters when models are fully implemented
    // Hive.registerAdapter(ResumeModelAdapter());
    // Hive.registerAdapter(ApplicationModelAdapter());
    // ...

    // Open boxes
    // await Hive.openBox<ResumeModel>(_resumesBoxName);
    // await Hive.openBox<ApplicationModel>(_applicationsBoxName);
  }

  // static Box<ResumeModel> get resumesBox => Hive.box<ResumeModel>(_resumesBoxName);
  // static Box<ApplicationModel> get applicationsBox => Hive.box<ApplicationModel>(_applicationsBoxName);
}
