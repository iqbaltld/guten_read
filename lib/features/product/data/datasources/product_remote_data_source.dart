import 'package:injectable/injectable.dart';
import '../../../../core/network/base_data_source.dart';

abstract class ProductRemoteDataSource {
  Future<List<String>> getCategories();
}

@Injectable(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final BaseDataSource _baseDataSource;

  ProductRemoteDataSourceImpl(this._baseDataSource);

  @override
  Future<List<String>> getCategories() async {
    return await _baseDataSource.get<List<String>>(
      '/products/categories',
      fromJson: (json) => List<String>.from(json),
    );
  }
}
