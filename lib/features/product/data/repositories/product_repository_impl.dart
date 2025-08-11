import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/responses/paginated_response_model.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

@Injectable(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final BaseRepository _baseRepository;

  ProductRepositoryImpl(
    this._remoteDataSource,
    this._baseRepository,
  );

  @override
  Future<Either<Failure, PaginatedResult<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
  }) async {
    return await _baseRepository.handleApiCall<PaginatedResult<Product>>(
      call: () => _remoteDataSource.getProducts(
        page: page,
        limit: limit,
        category: category,
      ),
      onSuccess: (response) => response,
      context: 'GetProducts',
    );
  }

  @override
  Future<Either<Failure, PaginatedResult<Product>>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    return await _baseRepository.handleApiCall<PaginatedResult<Product>>(
      call: () => _remoteDataSource.searchProducts(
        query: query,
        page: page,
        limit: limit,
      ),
      onSuccess: (response) => response,
      context: 'SearchProducts',
    );
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    return await _baseRepository.handleApiCall<Product>(
      call: () => _remoteDataSource.getProductById(id),
      onSuccess: (response) => response,
      context: 'GetProductById',
    );
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    return await _baseRepository.handleApiCall<List<String>>(
      call: () => _remoteDataSource.getCategories(),
      onSuccess: (response) => response,
      context: 'GetCategories',
    );
  }
}