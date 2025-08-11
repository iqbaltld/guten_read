import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'exceptions.dart';
import 'failures.dart';

@injectable
class ErrorHandler {
  Exception handleDioError(DioException error) {
    if (kDebugMode) {
      print(
        '🔴 API ERROR: ${error.requestOptions.method} ${error.requestOptions.uri}',
      );
      print('   Type: ${error.type}');
      if (error.response != null) {
        print('   Status: ${error.response!.statusCode}');
        print('   Response: ${error.response!.data}');
      }
    }

    if (error.response != null) {
      final response = error.response!;
      final errorMessage = _extractErrorMessage(response);

      return ServerException(
        message: errorMessage,
        statusCode: response.statusCode,
      );
    }

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
          message: 'Server took too long to respond.',
        );
      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'Connection error. Please check your internet connection.',
        );
      default:
        if (error.error is SocketException) {
          return const NetworkException(message: 'No internet connection.');
        }
        return ServerException(
          message: error.message ?? 'An unexpected error occurred',
        );
    }
  }

  Failure handleException(Exception exception, {String? context}) {
    if (kDebugMode) {
      print('🔴 ERROR${context != null ? ' [$context]' : ''}: $exception');
    }

    if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is LLMException) {
      return LLMFailure(exception.message);
    } else {
      return ServerFailure(exception.toString());
    }
  }

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
}
