import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  ConnectivityService() {
    _init();
  }

  Future<void> _init() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(ConnectivityResult result) {
    bool isConnected = result != ConnectivityResult.none;
    if (_isOnline != isConnected) {
      _isOnline = isConnected;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
