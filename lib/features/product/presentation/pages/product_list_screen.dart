import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/product_list_cubit.dart';
import '../widgets/product_card.dart';
import '../widgets/product_search_bar.dart';
import '../widgets/loading_widget.dart';

class ProductListScreen extends StatefulWidget {
  static const String routeName = '/products';
  
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductListCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: ProductSearchBar(
              onSearchChanged: (query) {
                context.read<ProductListCubit>().searchProducts(query);
              },
              onClearSearch: () {
                context.read<ProductListCubit>().clearSearch();
              },
            ),
          ),
          
          // Category Filter
          BlocBuilder<ProductListCubit, ProductListState>(
            buildWhen: (previous, current) => 
                current is ProductListLoaded && 
                (previous is! ProductListLoaded || 
                 previous.categories != current.categories),
            builder: (context, state) {
              if (state is ProductListLoaded && state.categories != null) {
                return Container(
                  height: 50.h,
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: state.categories!.length + 1,
                    separatorBuilder: (context, index) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return FilterChip(
                          label: const Text('All'),
                          selected: state.selectedCategory == null,
                          onSelected: (_) {
                            context.read<ProductListCubit>().clearFilter();
                          },
                        );
                      }
                      
                      final category = state.categories![index - 1];
                      return FilterChip(
                        label: Text(category),
                        selected: state.selectedCategory == category,
                        onSelected: (_) {
                          context.read<ProductListCubit>().applyFilter(
                            category: category,
                          );
                        },
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          // Products List
          Expanded(
            child: BlocBuilder<ProductListCubit, ProductListState>(
              builder: (context, state) {
                if (state is ProductListLoading) {
                  return const LoadingWidget();
                } else if (state is ProductListError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.sp,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          state.message,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProductListCubit>().fetchInitial();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is ProductListLoaded) {
                  if (state.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64.sp,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            state.isSearching 
                                ? 'No products found for "${state.searchQuery}"'
                                : 'No products available',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProductListCubit>().fetchInitial();
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: EdgeInsets.all(16.w),
                      itemCount: state.products.length + (state.hasMore ? 1 : 0),
                      separatorBuilder: (context, index) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        if (index == state.products.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        
                        return ProductCard(
                          product: state.products[index],
                        );
                      },
                    ),
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}