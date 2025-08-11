import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../error/error_handler.dart';
import '../error/exceptions.dart';

abstract class BaseDataSource {
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Options? options,
    T Function(dynamic data)? fromJson,
  });

  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    dynamic data,
    Options? options,
    T Function(dynamic data)? fromJson,
  });
}

@LazySingleton(as: BaseDataSource)
class BaseDataSourceImpl implements BaseDataSource {
  final Dio _dio;
  final ErrorHandler _errorHandler;

  BaseDataSourceImpl(this._dio, this._errorHandler);

  @override
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Options? options,
    T Function(dynamic data)? fromJson,
  }) async {
    return _makeRequest<T>(
      () => _dio.get(path, queryParameters: queryParams, options: options),
      fromJson: fromJson,
      debugInfo: 'GET $path',
    );
  }

  @override
  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    dynamic data,
    Options? options,
    T Function(dynamic data)? fromJson,
  }) async {
    return _makeRequest<T>(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      ),
      fromJson: fromJson,
      debugInfo: 'POST $path',
    );
  }

  Future<T> _makeRequest<T>(
    Future<Response> Function() request, {
    T Function(dynamic)? fromJson,
    required String debugInfo,
  }) async {
    try {
      if (kDebugMode) {
        print('🟡 API REQUEST: $debugInfo');
      }

      final response = await request();

      if (kDebugMode) {
        print('🟢 API SUCCESS: $debugInfo - Status: ${response.statusCode}');
      }

      return _handleResponse<T>(response, fromJson: fromJson);
    } on DioException catch (e) {
      throw _errorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('🔴 UNEXPECTED ERROR in $debugInfo: $e');
      }
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  T _handleResponse<T>(Response response, {T Function(dynamic)? fromJson}) {
    if (response.statusCode! < 200 || response.statusCode! >= 300) {
      throw ServerException(
        message: 'Request failed with status: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }

    final responseData = response.data;

    if (responseData is T) return responseData;

    if (T.toString() == 'void' || T.toString() == 'Null') return null as T;

    if (fromJson != null) {
      return fromJson(responseData);
    }

    return responseData as T;
  }
}
