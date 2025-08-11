part of 'product_list_cubit.dart';

sealed class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {
  const ProductListInitial();
}

class ProductListLoading extends ProductListState {
  const ProductListLoading();
}

class ProductListLoaded extends ProductListState {
  final List<Product> products;
  final List<String>? categories;
  final int currentPage;
  final bool hasMore;
  final bool isSearching;
  final String searchQuery;
  final String? selectedCategory;

  const ProductListLoaded({
    required this.products,
    this.categories,
    required this.currentPage,
    required this.hasMore,
    this.isSearching = false,
    this.searchQuery = '',
    this.selectedCategory,
  });

  ProductListLoaded copyWith({
    List<Product>? products,
    List<String>? categories,
    int? currentPage,
    bool? hasMore,
    bool? isSearching,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return ProductListLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
        products,
        categories,
        currentPage,
        hasMore,
        isSearching,
        searchQuery,
        selectedCategory,
      ];
}

class ProductListError extends ProductListState {
  final String message;

  const ProductListError(this.message);

  @override
  List<Object> get props => [message];
}