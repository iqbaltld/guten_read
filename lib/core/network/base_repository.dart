import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../error/error_handler.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';
import 'network_info.dart';

abstract class BaseRepository {
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
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final response = await call();

      if (onSuccess == null) {
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
    } on LLMException catch (e) {
      return Left(_errorHandler.handleException(e, context: context));
    } catch (e) {
      final serverException = ServerException(message: e.toString());
      return Left(
        _errorHandler.handleException(serverException, context: context),
      );
    }
  }
}
