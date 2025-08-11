import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

@Injectable(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final BaseRepository _baseRepository;

  ProductRepositoryImpl(this._remoteDataSource, this._baseRepository);

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    return await _baseRepository.handleApiCall<List<String>>(
      call: () => _remoteDataSource.getCategories(),
      onSuccess: (response) => response,
      context: 'GetCategories',
    );
  }
}
