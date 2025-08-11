import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/error_message_mapper.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';

part 'product_list_state.dart';

@injectable
class ProductListCubit extends Cubit<ProductListState> {
  final GetProductsUseCase _getProductsUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final ProductRepository _productRepository;

  ProductListCubit({
    required GetProductsUseCase getProductsUseCase,
    required SearchProductsUseCase searchProductsUseCase,
    required ProductRepository productRepository,
  }) : _getProductsUseCase = getProductsUseCase,
       _searchProductsUseCase = searchProductsUseCase,
       _productRepository = productRepository,
       super(const ProductListInitial());

  GetProductsParams _params = const GetProductsParams(page: 1, limit: 20);
  Timer? _debounceTimer;
  bool _areCategoriesLoaded = false;

  Future<void> getCategories() async {
    final result = await _productRepository.getCategories();
    result.fold(
      (failure) {
        // Handle category loading error silently or show a snackbar
      },
      (categories) {
        if (state is ProductListLoaded) {
          emit((state as ProductListLoaded).copyWith(categories: categories));
        }
      },
    );
  }

  void fetchInitial() async {
    final currentCategories = state is ProductListLoaded
        ? (state as ProductListLoaded).categories
        : null;

    emit(const ProductListLoading());

    _params = _params.copyWith(page: 1, category: _params.category);

    final result = await _getProductsUseCase(_params);

    result.fold(
      (failure) {
        emit(
          ProductListError(ErrorMessageMapper.getUserFriendlyMessage(failure)),
        );
      },
      (response) {
        emit(
          ProductListLoaded(
            products: response.items,
            currentPage: response.currentPage,
            hasMore: response.hasNextPage,
            categories: currentCategories,
            selectedCategory: _params.category,
          ),
        );

        if (!_areCategoriesLoaded) {
          getCategories();
          _areCategoriesLoaded = true;
        }
      },
    );
  }

  Future<void> searchProducts(String query) async {
    if (state is! ProductListLoaded) return;
    final loadedState = state as ProductListLoaded;

    if (loadedState.searchQuery == query) return;

    if (query.isEmpty) {
      clearSearch();
      return;
    }

    if (query.length < AppConstants.minSearchLength) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: AppConstants.searchDebounceTime),
      () async {
        emit(const ProductListLoading());

        final searchParams = SearchProductsParams(
          query: query,
          page: 1,
          limit: AppConstants.defaultPageSize,
        );

        final result = await _searchProductsUseCase(searchParams);

        result.fold(
          (failure) {
            emit(
              ProductListError(
                ErrorMessageMapper.getUserFriendlyMessage(failure),
              ),
            );
          },
          (response) {
            emit(
              loadedState.copyWith(
                products: response.items,
                currentPage: response.currentPage,
                hasMore: response.hasNextPage,
                isSearching: true,
                searchQuery: query,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (state is! ProductListLoaded) return;
    final currentState = state as ProductListLoaded;
    if (!currentState.hasMore) return;

    if (currentState.isSearching && currentState.searchQuery.isNotEmpty) {
      // Load more search results
      final searchParams = SearchProductsParams(
        query: currentState.searchQuery,
        page: currentState.currentPage + 1,
        limit: AppConstants.defaultPageSize,
      );

      final result = await _searchProductsUseCase(searchParams);

      result.fold(
        (failure) {
          emit(
            ProductListError(
              ErrorMessageMapper.getUserFriendlyMessage(failure),
            ),
          );
        },
        (response) {
          emit(
            currentState.copyWith(
              products: [...currentState.products, ...response.items],
              currentPage: response.currentPage,
              hasMore: response.hasNextPage,
              isSearching: true,
              searchQuery: currentState.searchQuery,
            ),
          );
        },
      );
    } else {
      // Load more regular results
      final nextParams = _params.copyWith(page: currentState.currentPage + 1);

      final result = await _getProductsUseCase(nextParams);

      result.fold(
        (failure) {
          emit(
            ProductListError(
              ErrorMessageMapper.getUserFriendlyMessage(failure),
            ),
          );
        },
        (response) {
          emit(
            currentState.copyWith(
              products: [...currentState.products, ...response.items],
              currentPage: response.currentPage,
              hasMore: response.hasNextPage,
            ),
          );
        },
      );
    }
  }

  void applyFilter({String? category}) {
    _params = _params.copyWith(category: category);
    fetchInitial();
  }

  void clearFilter() {
    _params = _params.copyWith(category: null);
    fetchInitial();
  }

  void clearSearch() {
    fetchInitial();
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
