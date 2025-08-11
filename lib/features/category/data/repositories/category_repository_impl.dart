import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;
  final BaseRepository _baseRepository;

  CategoryRepositoryImpl(this._remoteDataSource, this._baseRepository);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    return await _baseRepository.handleApiCall<List<Category>>(
      call: () => _remoteDataSource.getCategories(),
      onSuccess: (response) => response,
      context: 'GetCategories',
    );
  }
}
