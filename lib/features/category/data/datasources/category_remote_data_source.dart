import 'package:injectable/injectable.dart';
import '../../../../core/network/base_data_source.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

@LazySingleton(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final BaseDataSource _baseDataSource;

  CategoryRemoteDataSourceImpl(this._baseDataSource);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _baseDataSource.get<List<dynamic>>(
      '/products/categories',
    );
    
    return response
        .map((categoryJson) => CategoryModel(
              slug: categoryJson['slug'] as String,
              name: categoryJson['name'] as String,
              url: categoryJson['url'] as String,
            ))
        .toList();
  }
}
