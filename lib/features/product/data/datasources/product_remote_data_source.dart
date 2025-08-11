import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/base_data_source.dart';
import '../../../../core/responses/paginated_response_model.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<PaginatedResult<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
  });

  Future<PaginatedResult<ProductModel>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
  });

  Future<ProductModel> getProductById(int id);

  Future<List<String>> getCategories();
}

@Injectable(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final BaseDataSource _baseDataSource;

  ProductRemoteDataSourceImpl(this._baseDataSource);

  @override
  Future<PaginatedResult<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
  }) async {
    final skip = (page - 1) * limit;
    
    String endpoint = ApiEndpoint.products;
    Map<String, dynamic> queryParams = {
      'limit': limit,
      'skip': skip,
    };

    if (category != null && category.isNotEmpty) {
      endpoint = '/products/category/$category';
    }

    return await _baseDataSource.getPaginated<ProductModel>(
      endpoint,
      params: queryParams,
      fromJson: (json) => ProductModel.fromJson(json),
    );
  }

  @override
  Future<PaginatedResult<ProductModel>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    final skip = (page - 1) * limit;
    
    return await _baseDataSource.getPaginated<ProductModel>(
      ApiEndpoint.searchProducts,
      params: {
        'q': query,
        'limit': limit,
        'skip': skip,
      },
      fromJson: (json) => ProductModel.fromJson(json),
    );
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    return await _baseDataSource.get<ProductModel>(
      '${ApiEndpoint.products}/$id',
      fromJson: (json) => ProductModel.fromJson(json),
    );
  }

  @override
  Future<List<String>> getCategories() async {
    return await _baseDataSource.get<List<String>>(
      '/products/categories',
      fromJson: (json) => List<String>.from(json),
    );
  }
}