class LocalUser {
  const LocalUser({
    required this.name,
    required this.email,
  });

  final String name;
  final String email;
}

class AuthResult {
  const AuthResult({
    required this.user,
    required this.requiresEmailConfirmation,
  });

  final LocalUser? user;
  final bool requiresEmailConfirmation;
}

abstract class AuthRepository {
  Future<LocalUser?> getStoredSession();

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  });

  Future<LocalUser> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> resetPassword({
    required String email,
  });
}

class TravelBuddyAuthException implements Exception {
  const TravelBuddyAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
