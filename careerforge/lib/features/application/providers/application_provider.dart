import 'package:flutter/material.dart';
import '../data/models/application_model.dart';
import '../../../../services/hive_service.dart';
import '../../../../core/utils/id_generator.dart';

class ApplicationProvider extends ChangeNotifier {
  List<ApplicationModel> _applications = [];
  List<ApplicationModel> _filteredApplications = [];
  
  ApplicationStatus? _activeStatusFilter;
  DateTimeRange? _activeDateFilter;
  String _searchQuery = '';
  
  bool _isLoading = false;
  // ignore: prefer_final_fields
  bool _isSyncing = false;
  String? _errorMessage;

  List<ApplicationModel> get applications => _applications;
  List<ApplicationModel> get filteredApplications => _filteredApplications;
  ApplicationStatus? get activeStatusFilter => _activeStatusFilter;
  DateTimeRange? get activeDateFilter => _activeDateFilter;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;
  String? get errorMessage => _errorMessage;

  Future<void> loadApplications() async {
    _setLoading(true);
    try {
      final box = HiveService.applicationsBox;
      _applications = box.values.toList();
      _applications.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
      _applyFilters();
    } catch (e) {
      _errorMessage = 'Failed to load applications: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addApplication(ApplicationModel application) async {
    _setLoading(true);
    try {
      final box = HiveService.applicationsBox;
      await box.put(application.applicationId, application);
      await loadApplications();
    } catch (e) {
      _errorMessage = 'Failed to add application: $e';
      _setLoading(false);
    }
  }

  Future<void> updateApplication(ApplicationModel application) async {
    _setLoading(true);
    try {
      final box = HiveService.applicationsBox;
      application.lastUpdated = DateTime.now();
      await box.put(application.applicationId, application);
      await loadApplications();
    } catch (e) {
      _errorMessage = 'Failed to update application: $e';
      _setLoading(false);
    }
  }

  Future<void> deleteApplication(String id) async {
    _setLoading(true);
    try {
      final box = HiveService.applicationsBox;
      await box.delete(id);
      await loadApplications();
    } catch (e) {
      _errorMessage = 'Failed to delete application: $e';
      _setLoading(false);
    }
  }

  Future<void> updateStatus(String id, ApplicationStatus newStatus) async {
    try {
      final app = _applications.firstWhere((a) => a.applicationId == id);
      app.status = newStatus;
      await updateApplication(app);
    } catch (e) {
      _errorMessage = 'Application not found';
      notifyListeners();
    }
  }

  void searchApplications(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByStatus(ApplicationStatus? status) {
    _activeStatusFilter = status;
    _applyFilters();
  }

  void filterByDateRange(DateTimeRange? range) {
    _activeDateFilter = range;
    _applyFilters();
  }

  void clearFilters() {
    _activeStatusFilter = null;
    _activeDateFilter = null;
    _searchQuery = '';
    _applyFilters();
  }

  String generateApplicationId() {
    return IdGenerator.generateApplicationId(DateTime.now());
  }

  List<ApplicationModel> getApplicationsByResumeId(String resumeId) {
    return _applications.where((a) => a.resumeId == resumeId).toList();
  }

  void _applyFilters() {
    _filteredApplications = _applications.where((app) {
      // 1. Search Query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchCompany = app.companyName.toLowerCase().contains(query);
        final matchRole = app.jobRole.toLowerCase().contains(query);
        if (!matchCompany && !matchRole) return false;
      }

      // 2. Status Filter
      if (_activeStatusFilter != null && app.status != _activeStatusFilter) {
        return false;
      }

      // 3. Date Range Filter
      if (_activeDateFilter != null) {
        final date = app.dateApplied;
        if (date.isBefore(_activeDateFilter!.start) || date.isAfter(_activeDateFilter!.end)) {
          return false;
        }
      }

      return true;
    }).toList();

    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }
}
