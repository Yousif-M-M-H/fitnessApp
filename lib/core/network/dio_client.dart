import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor to automatically add auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('jwt_token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint('🌐 API: $obj'),
        ),
      );
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        // Try to extract the actual error message from the backend
        final response = error.response;
        if (response?.data != null) {
          try {
            final data = response!.data;
            // Backend sends error in "message" field
            if (data is Map<String, dynamic> && data['message'] != null) {
              return Exception(data['message']);
            }
            // If there's a validation error with details
            if (data is Map<String, dynamic> && data['error'] != null) {
              return Exception(data['error']);
            }
          } catch (e) {
            // If parsing fails, use status code message
          }
        }
        return Exception(_handleStatusCode(error.response?.statusCode));
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      case DioExceptionType.connectionError:
        return Exception('Cannot connect to server. Make sure backend is running and you\'re on the same WiFi.');
      default:
        return Exception('Network error. Please check your connection.');
    }
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid input. Please check all fields are filled correctly.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden. Please check your credentials.';
      case 404:
        return 'Resource not found. Please check the URL.';
      case 409:
        return 'Email or phone number already exists. Please use different credentials.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
