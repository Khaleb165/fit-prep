import 'package:flutter/foundation.dart';

import '../core/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required AuthService authService,
  }) : _authService = authService;

  final AuthService _authService;

  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
  }) {
    return _runAuthAction(
      () => _authService.signUp(
        username: username.trim(),
        email: email.trim(),
        password: password,
      ),
    );
  }

  Future<bool> signIn({
    required String username,
    required String password,
  }) {
    return _runAuthAction(
      () => _authService.signIn(
        username: username.trim(),
        password: password,
      ),
    );
  }

  Future<bool> _runAuthAction(Future<void> Function() action) async {
    _setLoading(true);

    try {
      await action();
      _isAuthenticated = true;
      _errorMessage = null;
      return true;
    } on AuthException catch (error) {
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    if (value) {
      _errorMessage = null;
    }
    notifyListeners();
  }
}
