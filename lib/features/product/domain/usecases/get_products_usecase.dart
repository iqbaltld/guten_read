import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/responses/paginated_response_model.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, PaginatedResult<Product>>> call(
    GetProductsParams params,
  ) async {
    return await repository.getProducts(
      page: params.page,
      limit: params.limit,
      category: params.category,
    );
  }
}

class GetProductsParams extends Equatable {
  final int page;
  final int limit;
  final String? category;

  const GetProductsParams({this.page = 1, this.limit = 20, this.category});

  GetProductsParams copyWith({int? page, int? limit, String? category}) {
    return GetProductsParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [page, limit, category];
}
