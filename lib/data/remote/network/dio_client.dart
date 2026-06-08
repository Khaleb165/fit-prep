import 'dart:convert';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dio_exceptions.dart';
import 'interceptor/token_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient.internal();

  factory DioClient() => _instance;

  static late Dio _dio;
  static bool _isInitialized = false;

  DioClient.internal();

  Future<void> initDioClient() async {
    final serverUrl = dotenv.env['API_URL_DEV'] ?? '';
    if (serverUrl.isEmpty) {
      throw Exception('API_URL_DEV is missing from .env');
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: '$serverUrl/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );

    final tokenInterceptor = TokenInterceptor(_dio);

    _dio.interceptors.addAll([
      AwesomeDioInterceptor(logger: print),
      tokenInterceptor,
    ]);
    _isInitialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initDioClient();
    }
  }

  // get endpoint
  Future get(String endpoint,
      [Map<String, dynamic>? queryParameters, String token = '']) async {
    Response response;
    try {
      await _ensureInitialized();
      response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw (errorMessage);
    }
  }

  // post endpoint
  Future<dynamic> post(String endpoint, dynamic data,
      {Map<String, dynamic>? headers}) async {
    Response response;

    try {
      await _ensureInitialized();
      debugPrint("Body: $data");
      Options options = Options(headers: headers);

      // Make the POST request with optional headers
      response = await _dio.post(endpoint, data: data, options: options);

      return response.data;
    } on DioException catch (e) {
      debugPrint("Error Message: ${e.message}");
      if (e.response != null) {
        debugPrint("Error Response Data: ${e.response?.data}");
        debugPrint("Error Response Headers: ${e.response?.headers}");
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw (errorMessage);
    }
  }

  Future<dynamic> patch(String endpoint, dynamic data,
      {Map<String, dynamic>? headers}) async {
    try {
      await _ensureInitialized();
      // Check if body is a Map and encode it to JSON if necessary
      if (data is Map<String, dynamic>) {
        data = json.encode(data);
      }

      Options options = Options(headers: headers);
      final response = await _dio.patch(
        endpoint,
        data: data,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      debugPrint("Error Message: ${e.message}");
      if (e.response != null) {
        debugPrint("Error Response Data: ${e.response?.data}");
        debugPrint("Error Response Headers: ${e.response?.headers}");
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw (errorMessage);
    }
  }

  // delete endpoint
  Future<dynamic> delete(String endpoint,
      {Map<String, dynamic>? headers}) async {
    try {
      await _ensureInitialized();
      Options options = Options(headers: headers);
      final response = await _dio.delete(endpoint, options: options);
      return response.data;
    } on DioException catch (e) {
      debugPrint("Error Message: ${e.message}");
      if (e.response != null) {
        debugPrint("Error Response Data: ${e.response?.data}");
        debugPrint("Error Response Headers: ${e.response?.headers}");
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw (errorMessage);
    }
  }
}
