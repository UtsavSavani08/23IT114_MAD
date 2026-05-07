import 'package:flutter/foundation.dart';
import '../data/models/resume_model.dart';
import '../../../../services/hive_service.dart';
import '../../../../core/utils/id_generator.dart';

class ResumeProvider extends ChangeNotifier {
  List<ResumeModel> _resumes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ResumeModel> get resumes => _resumes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadResumes() async {
    _setLoading(true);
    try {
      final box = HiveService.resumesBox;
      _resumes = box.values.toList();
      _resumes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      _errorMessage = 'Failed to load resumes: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addResume(ResumeModel resume) async {
    _setLoading(true);
    try {
      final box = HiveService.resumesBox;
      await box.put(resume.id, resume);
      await loadResumes();
    } catch (e) {
      _errorMessage = 'Failed to add resume: $e';
      _setLoading(false);
    }
  }

  Future<void> updateResume(ResumeModel resume) async {
    _setLoading(true);
    try {
      final box = HiveService.resumesBox;
      resume.updatedAt = DateTime.now();
      await box.put(resume.id, resume);
      await loadResumes();
    } catch (e) {
      _errorMessage = 'Failed to update resume: $e';
      _setLoading(false);
    }
  }

  Future<void> deleteResume(String id) async {
    _setLoading(true);
    try {
      final box = HiveService.resumesBox;
      await box.delete(id);
      await loadResumes();
    } catch (e) {
      _errorMessage = 'Failed to delete resume: $e';
      _setLoading(false);
    }
  }

  ResumeModel? getResumeById(String id) {
    try {
      return _resumes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> duplicateResume(String id) async {
    final original = getResumeById(id);
    if (original == null) return;

    final duplicated = original.copyWith(
      id: IdGenerator.generateUuid(),
      profileName: '${original.profileName} (Copy)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await addResume(duplicated);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }
}
