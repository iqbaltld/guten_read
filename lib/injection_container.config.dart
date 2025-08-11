// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'core/error/error_handler.dart' as _i16;
import 'core/network/base_data_source.dart' as _i294;
import 'core/network/custom_interceptor.dart' as _i408;
import 'core/network/network_info.dart' as _i75;
import 'core/repositories/base_repository.dart' as _i64;
import 'core/services/navigation_service.dart' as _i355;
import 'features/category/data/datasources/category_remote_data_source.dart'
    as _i188;
import 'features/category/data/repositories/category_repository_impl.dart'
    as _i44;
import 'features/category/domain/repositories/category_repository.dart' as _i5;
import 'features/category/presentation/cubit/category_cubit.dart' as _i478;
import 'features/product/data/datasources/product_remote_data_source.dart'
    as _i317;
import 'features/product/data/repositories/product_repository_impl.dart'
    as _i531;
import 'features/product/domain/repositories/product_repository.dart' as _i841;
import 'features/product/presentation/cubit/product_list_cubit.dart' as _i89;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i16.ErrorHandler>(() => _i16.ErrorHandler());
    gh.lazySingleton<_i294.BaseDataSource>(
      () => _i294.BaseDataSourceImpl(gh<_i361.Dio>(), gh<_i16.ErrorHandler>()),
    );
    gh.factory<_i361.Interceptor>(
      () => _i408.CustomInterceptor(
        gh<_i460.SharedPreferences>(),
        gh<_i355.NavigationService>(),
      ),
    );
    gh.factory<_i75.NetworkInfo>(
      () => _i75.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.factory<_i317.ProductRemoteDataSource>(
      () => _i317.ProductRemoteDataSourceImpl(gh<_i294.BaseDataSource>()),
    );
    gh.lazySingleton<_i188.CategoryRemoteDataSource>(
      () => _i188.CategoryRemoteDataSourceImpl(gh<_i294.BaseDataSource>()),
    );
    gh.factory<_i64.BaseRepository>(
      () => _i64.BaseRepositoryImpl(
        networkInfo: gh<_i75.NetworkInfo>(),
        errorHandler: gh<_i16.ErrorHandler>(),
      ),
    );
    gh.lazySingleton<_i5.CategoryRepository>(
      () => _i44.CategoryRepositoryImpl(
        gh<_i188.CategoryRemoteDataSource>(),
        gh<_i64.BaseRepository>(),
      ),
    );
    gh.factory<_i841.ProductRepository>(
      () => _i531.ProductRepositoryImpl(
        gh<_i317.ProductRemoteDataSource>(),
        gh<_i64.BaseRepository>(),
      ),
    );
    gh.factory<_i478.CategoryCubit>(
      () => _i478.CategoryCubit(gh<_i5.CategoryRepository>()),
    );
    gh.factory<_i89.ProductListCubit>(
      () => _i89.ProductListCubit(
        productRepository: gh<_i841.ProductRepository>(),
      ),
    );
    return this;
  }
}
