import 'dart:async';
import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:fit_prep/data/offline/hive.dart';
import 'package:flutter/material.dart';

import '../../../../model/sign_in.dart';

class TokenInterceptor extends Interceptor {
  static const String _skipAuthTokenKey = 'skip_auth_token';
  static const String _skipAuthRefreshKey = 'skip_auth_refresh';

  final Dio _dio;
  bool _isRefreshing = false;
  late final Queue<PendingRequest> _queue;
  final _storage = HiveStorage.instance;

  TokenInterceptor(this._dio) {
    _queue = Queue();
    debugPrint('TokenInterceptor initialized');
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint(
        'TokenInterceptor onRequest -> ${options.method} ${options.path}');

    if (options.extra[_skipAuthTokenKey] == true) {
      handler.next(options);
      return;
    }

    final token = await _storage.getToken();
    // ignore: unnecessary_null_comparison
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint('Added Authorization header: Bearer $token');
    } else {
      debugPrint('No token found in HiveStorage');
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final message = _errorMessageFrom(err.response?.data);
    debugPrint(
      'TokenInterceptor onError -> status: $status, message: $message',
    );

    final shouldRefresh = status == 401 &&
        err.requestOptions.extra[_skipAuthRefreshKey] != true &&
        _isExpiredTokenMessage(message);

    if (shouldRefresh) {
      debugPrint('Queueing failed request: ${err.requestOptions.path}');
      _queue.add(PendingRequest(err.requestOptions, handler));
      if (!_isRefreshing) {
        _isRefreshing = true;
        debugPrint('Refreshing token...');
        try {
          await _refreshToken();
          final newToken = await _storage.getToken();
          debugPrint('New token acquired: $newToken');
          for (final pending in _queue) {
            debugPrint('Retrying request: ${pending.options.path}');
            pending.options.headers['Authorization'] = 'Bearer $newToken';
            final clone = await _dio.request(
              pending.options.path,
              data: pending.options.data,
              queryParameters: pending.options.queryParameters,
              options: Options(
                method: pending.options.method,
                headers: pending.options.headers,
                contentType: pending.options.contentType,
                responseType: pending.options.responseType,
              ),
            );
            debugPrint('Response for retried request: ${clone.statusCode}');
            pending.handler.resolve(clone);
          }
        } catch (e) {
          debugPrint('Error refreshing token: $e');
          for (final pending in _queue) {
            pending.handler.next(err);
          }
        } finally {
          _queue.clear();
          _isRefreshing = false;
          debugPrint('Token refresh process completed');
        }
      }
    } else {
      handler.next(err);
    }
  }

  Future<void> _refreshToken() async {
    debugPrint('TokenInterceptor _refreshToken called');
    final username = await _storage.getUsername();
    final password = await _storage.getPassword();
    if (username == null ||
        username.isEmpty ||
        password == null ||
        password.isEmpty) {
      throw StateError('Stored credentials are missing.');
    }

    final credentials = SignInModel(username: username, password: password);
    debugPrint('Refreshing token with credentials for user: $username');

    final response = await _dio.post(
      '/auth/login',
      options: Options(
        extra: const {
          _skipAuthTokenKey: true,
          _skipAuthRefreshKey: true,
        },
      ),
      data: credentials.toJson(),
    );
    debugPrint(
        'Refresh token response: ${response.statusCode} ${response.data}');

    final responseData = response.data;
    final newToken = responseData is Map
        ? (responseData['token'] ?? responseData['access_token'])?.toString()
        : null;
    if (newToken == null || newToken.isEmpty) {
      throw StateError('Token refresh response did not include a token.');
    }

    await _storage.setToken(newToken);
    debugPrint('Token saved to HiveStorage: $newToken');
  }

  String? _errorMessageFrom(dynamic data) {
    if (data is Map) {
      return (data['error'] ?? data['detail'] ?? data['message'])?.toString();
    }

    return data?.toString();
  }

  bool _isExpiredTokenMessage(String? message) {
    return message == 'Invalid or expired token.' ||
        message == 'Could not validate credentials';
  }
}

class PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;
  PendingRequest(this.options, this.handler);
}
