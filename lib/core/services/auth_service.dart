abstract class AuthService {
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  });

  Future<void> signIn({
    required String username,
    required String password,
  });
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}

class MockAuthService implements AuthService {
  const MockAuthService();

  static const Duration _mockDelay = Duration(milliseconds: 600);

  @override
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_mockDelay);
    _throwIfMockFailure(username);
  }

  @override
  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(_mockDelay);
    _throwIfMockFailure(username);
  }

  void _throwIfMockFailure(String username) {
    if (username.trim().toLowerCase() == 'error') {
      throw const AuthException(
        'Authentication failed. Please try again.',
      );
    }
  }
}
