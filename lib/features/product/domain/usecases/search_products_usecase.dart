import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/responses/paginated_response_model.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

@injectable
class SearchProductsUseCase {
  final ProductRepository repository;

  SearchProductsUseCase(this.repository);

  Future<Either<Failure, PaginatedResult<Product>>> call(
    SearchProductsParams params,
  ) async {
    return await repository.searchProducts(
      query: params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchProductsParams extends Equatable {
  final String query;
  final int page;
  final int limit;

  const SearchProductsParams({
    required this.query,
    this.page = 1,
    this.limit = 20,
  });

  SearchProductsParams copyWith({String? query, int? page, int? limit}) {
    return SearchProductsParams(
      query: query ?? this.query,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object> get props => [query, page, limit];
}
