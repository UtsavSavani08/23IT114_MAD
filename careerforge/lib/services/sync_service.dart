// ignore_for_file: avoid_print, unused_field
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/connectivity_service.dart';
import 'api_service.dart';

class SyncService {
  final ConnectivityService _connectivityService;
  final ApiService _apiService;
  static const String _pendingSyncKey = 'pendingSync';

  SyncService(this._connectivityService, this._apiService);

  Future<void> setPendingChanges(bool pending) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pendingSyncKey, pending);
  }

  Future<bool> hasPendingChanges() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_pendingSyncKey) ?? false;
  }

  Future<void> syncToBackend() async {
    if (!_connectivityService.isOnline) return;

    final hasChanges = await hasPendingChanges();
    if (!hasChanges) return;

    try {
      // Mock sync logic
      // await _apiService.postResumes(resumes);
      // await _apiService.postApplications(applications);
      
      await setPendingChanges(false);
    } catch (e) {
      // Handle DioException here
      print('Sync to backend failed: $e');
    }
  }

  Future<void> syncFromBackend() async {
    if (!_connectivityService.isOnline) return;

    try {
      // Mock fetch logic
      // final updates = await _apiService.getApplications();
      // update local hive boxes...
    } catch (e) {
      print('Sync from backend failed: $e');
    }
  }
}
