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

import 'core/network/api_manager.dart' as _i90;
import 'core/network/base_repository.dart' as _i116;
import 'core/network/custom_interceptor.dart' as _i408;
import 'core/network/error/error_handler.dart' as _i699;
import 'core/network/network_info.dart' as _i75;
import 'features/book_analyzer/data/datasources/gutenberg_data_source.dart'
    as _i874;
import 'features/book_analyzer/data/datasources/llm_data_source.dart' as _i984;
import 'features/book_analyzer/data/repositories/book_analyzer_repository_impl.dart'
    as _i21;
import 'features/book_analyzer/domain/repositories/book_analyzer_repository.dart'
    as _i19;
import 'features/book_analyzer/domain/usecases/analyze_characters_usecase.dart'
    as _i874;
import 'features/book_analyzer/domain/usecases/download_book_usecase.dart'
    as _i600;
import 'features/book_analyzer/presentation/cubit/book_analyzer_cubit.dart'
    as _i288;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i699.ErrorHandler>(() => _i699.ErrorHandler());
    gh.lazySingleton<_i90.ApiManager>(() => _i90.ApiManagerImpl(
          gh<_i361.Dio>(),
          gh<_i699.ErrorHandler>(),
        ));
    gh.factory<_i361.Interceptor>(() => _i408.CustomInterceptor());
    gh.factory<_i75.NetworkInfo>(
        () => _i75.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.factory<_i874.GutenbergDataSource>(
        () => _i874.GutenbergDataSourceImpl(gh<_i90.ApiManager>()));
    gh.factory<_i984.LLMDataSource>(
        () => _i984.LLMDataSourceImpl(gh<_i90.ApiManager>()));
    gh.factory<_i116.BaseRepository>(() => _i116.BaseRepositoryImpl(
          networkInfo: gh<_i75.NetworkInfo>(),
          errorHandler: gh<_i699.ErrorHandler>(),
        ));
    gh.factory<_i19.BookAnalyzerRepository>(
        () => _i21.BookAnalyzerRepositoryImpl(
              gh<_i874.GutenbergDataSource>(),
              gh<_i984.LLMDataSource>(),
              gh<_i116.BaseRepository>(),
            ));
    gh.factory<_i874.AnalyzeCharactersUseCase>(() =>
        _i874.AnalyzeCharactersUseCase(gh<_i19.BookAnalyzerRepository>()));
    gh.factory<_i600.DownloadBookUseCase>(
        () => _i600.DownloadBookUseCase(gh<_i19.BookAnalyzerRepository>()));
    gh.factory<_i288.BookAnalyzerCubit>(() => _i288.BookAnalyzerCubit(
          downloadBookUseCase: gh<_i600.DownloadBookUseCase>(),
          analyzeCharactersUseCase: gh<_i874.AnalyzeCharactersUseCase>(),
        ));
    return this;
  }
}
