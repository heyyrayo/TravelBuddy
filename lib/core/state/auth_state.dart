import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends ChangeNotifier {
  AuthState();

  String? _token;
  String? _displayName;
  bool _isLoading = false;

  bool get isAuthenticated => _token != null;
  String? get displayName => _displayName;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _displayName = prefs.getString('display_name');
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));
    _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    _displayName = email.split('@').first;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', _token!);
    await prefs.setString('display_name', _displayName!);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1500));
    _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    _displayName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', _token!);
    await prefs.setString('display_name', name);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _displayName = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('display_name');
    notifyListeners();
  }
}
