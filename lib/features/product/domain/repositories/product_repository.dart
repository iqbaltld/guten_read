import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/responses/paginated_response_model.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, PaginatedResult<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
  });

  Future<Either<Failure, PaginatedResult<Product>>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, Product>> getProductById(int id);

  Future<Either<Failure, List<String>>> getCategories();
}
