import 'package:flutter/foundation.dart';
import '../../application/data/models/application_model.dart';
import '../../application/providers/application_provider.dart';

class DashboardProvider extends ChangeNotifier {
  final ApplicationProvider _applicationProvider;

  DashboardProvider(this._applicationProvider) {
    // Listen to changes in ApplicationProvider to automatically refresh stats
    _applicationProvider.addListener(refresh);
    refresh();
  }

  int _totalApplications = 0;
  Map<ApplicationStatus, int> _statusDistribution = {};
  List<ApplicationModel> _recentApplications = [];
  double _successRate = 0.0;
  int _activeApplications = 0;

  int get totalApplications => _totalApplications;
  Map<ApplicationStatus, int> get statusDistribution => _statusDistribution;
  List<ApplicationModel> get recentApplications => _recentApplications;
  double get successRate => _successRate;
  int get activeApplications => _activeApplications;

  void refresh() {
    final applications = _applicationProvider.applications;
    
    _totalApplications = applications.length;

    // Calculate status distribution
    _statusDistribution = {
      for (var status in ApplicationStatus.values) status: 0
    };
    
    int selectedCount = 0;
    _activeApplications = 0;

    for (var app in applications) {
      _statusDistribution[app.status] = (_statusDistribution[app.status] ?? 0) + 1;
      
      if (app.status == ApplicationStatus.selected) {
        selectedCount++;
      } else if (app.status == ApplicationStatus.applied || 
                 app.status == ApplicationStatus.shortlisted || 
                 app.status == ApplicationStatus.interviewScheduled) {
        _activeApplications++;
      }
    }

    // Calculate success rate
    if (_totalApplications > 0) {
      _successRate = (selectedCount / _totalApplications) * 100;
    } else {
      _successRate = 0.0;
    }

    // Get recent applications (last 5, sorted by dateApplied desc)
    final sorted = List<ApplicationModel>.from(applications)
      ..sort((a, b) => b.dateApplied.compareTo(a.dateApplied));
    
    _recentApplications = sorted.take(5).toList();

    notifyListeners();
  }

  @override
  void dispose() {
    _applicationProvider.removeListener(refresh);
    super.dispose();
  }
}
