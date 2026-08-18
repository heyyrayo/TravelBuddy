import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({
    SupabaseClient? client,
  }) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<LocalUser?> getStoredSession() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return null;
    }

    return LocalUser(
      name: _displayName(user),
      email: user.email ?? '',
    );
  }

  @override
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final trimmedName = name.trim();
    final normalizedEmail = email.trim().toLowerCase();

    _validateName(trimmedName);
    _validateEmail(normalizedEmail);
    _validatePassword(password);

    try {
      final response = await _client.auth.signUp(
        email: normalizedEmail,
        password: password,
        data: {
          'full_name': trimmedName,
        },
      );

      final user = response.user;

      if (user == null) {
        throw const TravelBuddyAuthException(
          'Unable to create your account. Please try again.',
        );
      }

      final requiresConfirmation = response.session == null;

      return AuthResult(
        user: LocalUser(
          name: trimmedName,
          email: user.email ?? normalizedEmail,
        ),
        requiresEmailConfirmation: requiresConfirmation,
      );
    } on AuthApiException catch (error) {
      throw TravelBuddyAuthException(
        _mapAuthError(error.message),
      );
    } on TravelBuddyAuthException {
      rethrow;
    } catch (_) {
      throw const TravelBuddyAuthException(
        'Unable to create your account. Please try again.',
      );
    }
  }

  @override
  Future<LocalUser> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    _validateEmail(normalizedEmail);

    if (password.isEmpty) {
      throw const TravelBuddyAuthException(
        'Please enter your password.',
      );
    }

    try {
      final response = await _client.auth.signInWithPassword(
        email: normalizedEmail,
        password: password,
      );

      final user = response.user;

      if (user == null || response.session == null) {
        throw const TravelBuddyAuthException(
          'Unable to sign in. Please try again.',
        );
      }

      return LocalUser(
        name: _displayName(user),
        email: user.email ?? normalizedEmail,
      );
    } on AuthApiException catch (error) {
      throw TravelBuddyAuthException(
        _mapAuthError(error.message),
      );
    } on TravelBuddyAuthException {
      rethrow;
    } catch (_) {
      throw const TravelBuddyAuthException(
        'Unable to sign in. Please try again.',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } on AuthApiException catch (error) {
      throw TravelBuddyAuthException(
        _mapAuthError(error.message),
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    _validateEmail(normalizedEmail);

    try {
      await _client.auth.resetPasswordForEmail(
        normalizedEmail,
      );
    } on AuthApiException catch (error) {
      throw TravelBuddyAuthException(
        _mapAuthError(error.message),
      );
    } catch (_) {
      throw const TravelBuddyAuthException(
        'Unable to send the password reset email.',
      );
    }
  }

  static void _validateName(String name) {
    if (name.isEmpty) {
      throw const TravelBuddyAuthException(
        'Please enter your full name.',
      );
    }

    if (name.length < 2) {
      throw const TravelBuddyAuthException(
        'Name must contain at least 2 characters.',
      );
    }
  }

  static void _validateEmail(String email) {
    if (email.isEmpty) {
      throw const TravelBuddyAuthException(
        'Please enter your email.',
      );
    }

    final valid = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email);

    if (!valid) {
      throw const TravelBuddyAuthException(
        'Please enter a valid email address.',
      );
    }
  }

  static void _validatePassword(String password) {
    if (password.length < 8) {
      throw const TravelBuddyAuthException(
        'Password must contain at least 8 characters.',
      );
    }
  }

  static String _displayName(User user) {
    final metadata = user.userMetadata;

    final name = metadata?['full_name']?.toString().trim();

    if (name != null && name.isNotEmpty) {
      return name;
    }

    final email = user.email;

    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }

    return 'Traveler';
  }

  static String _mapAuthError(String message) {
    final text = message.toLowerCase();

    if (text.contains('already registered') ||
        text.contains('user already registered')) {
      return 'An account with this email already exists.';
    }

    if (text.contains('invalid login credentials')) {
      return 'Incorrect email or password.';
    }

    if (text.contains('email not confirmed')) {
      return 'Please verify your email before signing in.';
    }

    return message;
  }
}
