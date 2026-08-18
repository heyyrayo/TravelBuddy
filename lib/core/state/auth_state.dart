import 'package:flutter/material.dart';

import '../data/auth_repository.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._repository);

  final AuthRepository _repository;

  LocalUser? _user;
  bool _isLoading = false;
  bool _emailConfirmationRequired = false;

  LocalUser? get user => _user;

  bool get isAuthenticated => _user != null;

  String? get displayName => _user?.name;

  String? get email => _user?.email;

  bool get isLoading => _isLoading;

  bool get emailConfirmationRequired => _emailConfirmationRequired;

  Future<void> init() async {
    _user = await _repository.getStoredSession();
    notifyListeners();
  }

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return _execute<AuthResult>(() async {
      final result = await _repository.register(
        name: name,
        email: email,
        password: password,
      );

      _emailConfirmationRequired = result.requiresEmailConfirmation;

      if (!result.requiresEmailConfirmation) {
        _user = result.user;
      }

      return result;
    });
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _execute<void>(() async {
      _user = await _repository.login(
        email: email,
        password: password,
      );

      _emailConfirmationRequired = false;
    });
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    await _execute<void>(() async {
      await _repository.resetPassword(
        email: email,
      );
    });
  }

  Future<void> logout() async {
    await _repository.logout();

    _user = null;
    _emailConfirmationRequired = false;

    notifyListeners();
  }

  Future<T> _execute<T>(
    Future<T> Function() operation,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      return await operation();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
