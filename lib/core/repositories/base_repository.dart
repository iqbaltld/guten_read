import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../error/error_handler.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';
import '../network/network_info.dart';

abstract class BaseRepository {
  /// Handles network calls with standard error handling
  Future<Either<Failure, T>> handleApiCall<T>({
    required Future<dynamic> Function() call,
    T Function(dynamic)? onSuccess,
    String? context,
  });
}

@Injectable(as: BaseRepository)
class BaseRepositoryImpl implements BaseRepository {
  final NetworkInfo _networkInfo;
  final ErrorHandler _errorHandler;

  BaseRepositoryImpl({
    required NetworkInfo networkInfo,
    required ErrorHandler errorHandler,
  }) : _networkInfo = networkInfo,
       _errorHandler = errorHandler;

  @override
  Future<Either<Failure, T>> handleApiCall<T>({
    required Future<dynamic> Function() call,
    T Function(dynamic)? onSuccess,
    String? context,
  }) async {
    // Check network connectivity
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final response = await call();

      // Handle success
      if (onSuccess == null) {
        // For void operations, return unit if T is Unit
        if (T.toString() == 'Unit') {
          return Right(unit as T);
        }
        throw Exception('onSuccess callback required for non-void operations');
      }

      return Right(onSuccess(response));
    } on ServerException catch (e) {
      return Left(_errorHandler.handleException(e, context: context));
    } on NetworkException catch (e) {
      return Left(_errorHandler.handleException(e, context: context));
    } on CacheException catch (e) {
      return Left(_errorHandler.handleException(e, context: context));
    } catch (e) {
      // Convert unknown exceptions to ServerException for consistent handling
      final serverException = ServerException(message: e.toString());
      return Left(
        _errorHandler.handleException(serverException, context: context),
      );
    }
  }
}
