import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'exceptions.dart';
import 'failures.dart';

@injectable
class ErrorHandler {
  /// Converts DioException to appropriate AppException with detailed logging
  Exception handleDioError(DioException error) {
    // Log the error details for debugging
    _logError(error);

    // Handle response errors (4xx, 5xx)
    if (error.response != null) {
      final response = error.response!;
      final errorMessage = _extractErrorMessage(response);

      return ServerException(
        message: errorMessage,
        statusCode: response.statusCode,
      );
    }

    // Handle connection/network errors
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.sendTimeout:
        return const NetworkException(
          message: 'Send timeout. Please try again.',
        );
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Server took too long to respond. Please try again.',
        );
      case DioExceptionType.badCertificate:
        return const NetworkException(
          message:
              'Invalid SSL certificate. Please check your system time and date.',
        );
      case DioExceptionType.badResponse:
        return ServerException(
          message: 'Server responded with an error',
          statusCode: 500,
        );
      case DioExceptionType.cancel:
        return const NetworkException(message: 'Request was cancelled');
      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'Connection error. Please check your internet connection.',
        );
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkException(
            message:
                'No internet connection. Please check your network settings.',
          );
        }
        return ServerException(
          message: error.message ?? 'An unexpected network error occurred',
        );
    }
  }

  /// Converts exceptions to appropriate failures
  Failure handleException(Exception exception, {String? context}) {
    // Log for debugging with context
    if (kDebugMode) {
      print('🔴 ERROR${context != null ? ' [$context]' : ''}: $exception');
      if (exception is ServerException && exception.statusCode != null) {
        print('   Status Code: ${exception.statusCode}');
      }
    }

    if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else {
      return ServerFailure(exception.toString());
    }
  }

  /// Extract meaningful error message from response
  String _extractErrorMessage(Response response) {
    if (response.data == null) return 'No data received from server';

    try {
      dynamic errorData = response.data;

      if (errorData is String) {
        return errorData.isNotEmpty ? errorData : 'Request failed';
      }

      if (errorData is Map) {
        return errorData['message']?.toString() ??
            errorData['error']?.toString() ??
            'Request failed with status ${response.statusCode}';
      }

      return 'Request failed with status ${response.statusCode}';
    } catch (e) {
      return 'Failed to parse server response';
    }
  }

  /// Enhanced error logging for debugging
  void _logError(DioException error) {
    if (!kDebugMode) return;

    print(
      '🔴 API ERROR: ${error.requestOptions.method} ${error.requestOptions.uri}',
    );
    print('   Type: ${error.type}');
    if (error.response != null) {
      print('   Status: ${error.response!.statusCode}');
      print('   Response: ${error.response!.data}');
    }
    if (error.requestOptions.data != null) {
      print('   Request Data: ${error.requestOptions.data}');
    }
    print('   Message: ${error.message}');
  }
}
