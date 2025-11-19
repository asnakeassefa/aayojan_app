import 'dart:convert';
import 'dart:developer';

import 'package:aayojan/features/auth/presentation/pages/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../main.dart';
import '../errors/exceptions.dart';
import '../errors/refresh_token_exception.dart';
import 'check_internet.dart';
import 'endpoints.dart';

class ApiService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiService() {
    _dio.options.connectTimeout =
        const Duration(milliseconds: 50000); // 50 seconds
    _dio.options.receiveTimeout =
        const Duration(milliseconds: 40000); // 40 seconds

    // Adding log interceptor for debugging
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    // Adding interceptor for request/response handling
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add Authorization token to headers
        final accessToken = await _secureStorage.read(key: 'accessToken');
        if (accessToken != null) {
          options.headers["Authorization"] = "Bearer $accessToken";
        }
        handler.next(options); // Continue the request
      },
      onResponse: (response, handler) {
        handler.next(response); // Continue the response
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          try {
            navigatorKey.currentState!
            .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
            // await _refreshAccessToken();
            // // Retry the failed request with the new token
            // final retryResponse = await _retryRequest(error.requestOptions);
            // handler.resolve(retryResponse);
          } catch (e) {
            log('Token refresh failed: ${e.toString()}');
            handler.next(DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              message: "Token Refresh Failed",
            ));
          }
        } else {
          handler.next(error); // Continue other errors
        }
      },
    ));
  }

  /// Retry the failed request
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }

  /// Refresh the access token
  Future<void> _refreshAccessToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refreshToken');
      if (refreshToken == null) {
        throw RefreshTokenExpiredException();
      }

      final response = await _dio.post(
        '${Endpoints.baseUrl}/auth/refresh',
        data: {"refreshToken": refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data["accessToken"];
        await _secureStorage.write(key: 'accessToken', value: newAccessToken);
      } else {
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
        throw RefreshTokenExpiredException();
      }
    } catch (e) {
      throw RefreshTokenExpiredException();
    }
  }

  /// Perform a POST request
  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    try {
      return await _dio.post(endpoint, data: data);
    } on DioException catch (e) {
      if (e.response?.statusCode.toString().startsWith('4') ?? false) {
        final errorsMap = e.response?.data['errors'] as Map<String, dynamic>?;
        log('errorsMap: $errorsMap');

        final errorMessage =
            errorsMap?.values.expand((value) => value as List).join('\n') ??
                'Unknown error occurred';
        throw ClientException(message: errorMessage);
      } else if (e.response?.statusCode.toString().startsWith('5') ?? false) {
        throw ServerException(message: 'Server error');
      }
      // check if it is time out exception and throw client error with timeout message
      else if (e.type == DioExceptionType.connectionTimeout) {
        throw ClientException(message: 'Connection timeout. Please try again.');
      } else {
        throw ('Something went wrong');
      }
    }
  }

  /// Perform a GET request
  Future<Response> get(String endpoint) async {
    try {
      final connection = await CheckInternet().hasInternetConnection();
      if (!connection) {
        throw ClientException(
            message:
                'Somthing went wrong!. Please check your internet connection!');
      }

      return await _dio.get(endpoint);
    } on DioException catch (e) {
      if (e.response?.statusCode.toString().startsWith('4') ?? false) {
        final errorsMap = e.response?.data['errors'] as Map<String, dynamic>?;
        log('errorsMap: $errorsMap');

        final errorMessage =
            errorsMap?.values.expand((value) => value as List).join('\n') ??
                'Unknown error occurred';

        throw ClientException(message: errorMessage);
      } else if (e.response?.statusCode.toString().startsWith('5') ?? false) {
        throw ServerException(message: 'Server error');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ClientException(message: 'Connection timeout. Please try again.');
      } else {
        throw ('Something went wrong');
      }
    }
  }

  /// Perform a PUT request
  Future<Response> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final connection = await CheckInternet().hasInternetConnection();
      if (!connection) {
        throw ClientException(
            message:
                'Somthing went wrong!. Please check your internet connection!');
      }
      return await _dio.put(endpoint, data: data);
    } on DioException catch (e) {
      if (e.response?.statusCode.toString().startsWith('4') ?? false) {
        final errorsMap = e.response?.data['errors'] as Map<String, dynamic>?;
        log('errorsMap: $errorsMap');

        final errorMessage =
            errorsMap?.values.expand((value) => value as List).join('\n') ??
                'Unknown error occurred';

        throw ClientException(message: errorMessage);
      } else if (e.response?.statusCode.toString().startsWith('5') ?? false) {
        throw ServerException(message: 'Server error');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ClientException(message: 'Connection timeout. Please try again.');
      } else {
        throw ('Something went wrong');
      }
    }
  }

  /// Perform a DELETE request
  Future<Response> delete(String endpoint) async {
    try {
      final connection = await CheckInternet().hasInternetConnection();
      if (!connection) {
        throw ClientException(
            message:
                'Somthing went wrong!. Please check your internet connection!');
      }
      return await _dio.delete(endpoint);
    } on DioException catch (e) {
      if (e.response?.statusCode.toString().startsWith('4') ?? false) {
        final errorsMap = e.response?.data['errors'] as Map<String, dynamic>?;
        log('errorsMap: $errorsMap');

        final errorMessage =
            errorsMap?.values.expand((value) => value as List).join('\n') ??
                'Unknown error occurred';

        throw ClientException(message: errorMessage);
      } else if (e.response?.statusCode.toString().startsWith('5') ?? false) {
        throw ServerException(message: 'Server error');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ClientException(message: 'Connection timeout. Please try again.');
      } else {
        throw ('Something went wrong');
      }
    }
  }

  /// Upload multipart form data (e.g., file upload)
  Future<Response> upload(String endpoint, FormData formData) async {
    try {
      final connection = await CheckInternet().hasInternetConnection();
      if (!connection) {
        throw ClientException(
            message:
                'Somthing went wrong!. Please check your internet connection!');
      }
      return await _dio.post(endpoint, data: formData);
    } on DioException catch (e) {
      if (e.response?.statusCode.toString().startsWith('4') ?? false) {
        final errorsMap = e.response?.data['errors'] as Map<String, dynamic>?;
        log('errorsMap: $errorsMap');

        final errorMessage =
            errorsMap?.values.expand((value) => value as List).join('\n') ??
                'Unknown error occurred';

        throw ClientException(message: errorMessage);
      } else if (e.response?.statusCode.toString().startsWith('5') ?? false) {
        throw ServerException(message: 'Server error');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ClientException(message: 'Connection timeout. Please try again.');
      } else {
        throw ('Something went wrong');
      }
    }
  }

  /// Edit multipart form data (e.g., file update)
  Future<Response> uploadFileUpdate(String endpoint, FormData formData) async {
    try {
      final connection = await CheckInternet().hasInternetConnection();
      if (!connection) {
        throw ClientException(
            message:
                'Somthing went wrong!. Please check your internet connection!');
      }
      return await _dio.put(endpoint, data: formData);
    } on DioException catch (e) {
      if (e.response?.statusCode.toString().startsWith('4') ?? false) {
        final errorsMap = e.response?.data['errors'] as Map<String, dynamic>?;
        log('errorsMap: $errorsMap');

        final errorMessage =
            errorsMap?.values.expand((value) => value as List).join('\n') ??
                'Unknown error occurred';

        throw ClientException(message: errorMessage);
      } else if (e.response?.statusCode.toString().startsWith('5') ?? false) {
        throw ServerException(message: 'Server error');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ClientException(message: 'Connection timeout. Please try again.');
      } else {
        throw ('Something went wrong');
      }
    }
  }
}
