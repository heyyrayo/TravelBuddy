import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityState extends ChangeNotifier {
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  Future<void> init() async {
    final results = await Connectivity().checkConnectivity();
    _isOnline = !results.contains(ConnectivityResult.none) || results.length > 1;
    notifyListeners();

    Connectivity().onConnectivityChanged.listen((results) {
      final nowOnline = !results.contains(ConnectivityResult.none) || results.length > 1;
      if (_isOnline != nowOnline) {
        _isOnline = nowOnline;
        notifyListeners();
      }
    });
  }
}
