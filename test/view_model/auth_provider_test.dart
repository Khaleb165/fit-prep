import 'package:fit_prep/core/services/auth_service.dart';
import 'package:fit_prep/view_model/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthProvider', () {
    test('signUp authenticates on mock success', () async {
      final AuthProvider provider = AuthProvider(
        authService: const MockAuthService(),
      );

      final bool isSuccessful = await provider.signUp(
        username: 'fit_user',
        email: 'fit@example.com',
        password: 'secret1',
      );

      expect(isSuccessful, isTrue);
      expect(provider.isAuthenticated, isTrue);
      expect(provider.errorMessage, isNull);
      expect(provider.isLoading, isFalse);
    });

    test('signIn exposes mock auth errors', () async {
      final AuthProvider provider = AuthProvider(
        authService: const MockAuthService(),
      );

      final bool isSuccessful = await provider.signIn(
        username: 'error',
        password: 'secret1',
      );

      expect(isSuccessful, isFalse);
      expect(provider.isAuthenticated, isFalse);
      expect(provider.errorMessage, 'Authentication failed. Please try again.');
      expect(provider.isLoading, isFalse);
    });
  });
}
