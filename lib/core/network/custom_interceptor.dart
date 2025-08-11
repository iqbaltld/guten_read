import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: Interceptor)
class CustomInterceptor extends Interceptor {
  CustomInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add common headers
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Pass through errors to be handled by BaseDataSource
    return handler.next(err);
  }
}
