import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

part 'product_list_state.dart';

@injectable
class ProductListCubit extends Cubit<ProductListState> {
  final ProductRepository _productRepository;

  ProductListCubit({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(const ProductListInitial());

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
}
