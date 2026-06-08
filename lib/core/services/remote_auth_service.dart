import 'package:fit_prep/data/offline/hive.dart';
import 'package:fit_prep/data/remote/network/dio_client.dart';

import 'auth_service.dart';

class RemoteAuthService implements AuthService {
  RemoteAuthService({
    DioClient? dioClient,
    HiveStorage? storage,
  })  : _dioClient = dioClient ?? DioClient(),
        _storage = storage ?? HiveStorage.instance;

  final DioClient _dioClient;
  final HiveStorage _storage;

  @override
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _request(
      '/auth/register',
      {
        'username': username.trim(),
        'email': email.trim(),
        'password': password,
      },
    );

    await _saveAuthSession(response);
  }

  @override
  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    final response = await _request(
      '/auth/login',
      {
        'username': username.trim(),
        'password': password,
      },
    );

    await _saveAuthSession(response);
  }

  // log out and clear session data
  Future<void> signOut() async {
    await _storage.clearSession();
  }

  Future<Map<String, dynamic>> _request(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dioClient.post(endpoint, body);
      if (response is Map<String, dynamic>) {
        return response;
      }

      throw const AuthException('Unexpected response from server.');
    } on AuthException {
      rethrow;
    } catch (error) {
      throw AuthException(error.toString());
    }
  }

  Future<void> _saveAuthSession(Map<String, dynamic> response) async {
    final token = response['token']?.toString();
    final user = response['user'];

    if (token == null || token.isEmpty) {
      throw const AuthException('Server did not return an auth token.');
    }

    await _storage.setToken(token);
    await _storage.setIsLoggedIn(true);

    if (user is Map<String, dynamic>) {
      final username = user['username']?.toString();
      final email = user['email']?.toString();

      if (username != null && username.isNotEmpty) {
        await _storage.setUsername(username);
      }
      if (email != null && email.isNotEmpty) {
        await _storage.setEmail(email);
      }
    }
  }
}
