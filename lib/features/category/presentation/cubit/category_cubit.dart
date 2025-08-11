import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

part 'category_state.dart';

@injectable
class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryCubit(this._categoryRepository) : super(const CategoryInitial());

  Future<void> loadCategories() async {
    emit(const CategoryLoading());
    
    final result = await _categoryRepository.getCategories();
    
    result.fold(
      (failure) {
        emit(CategoryError(message: 'Failed to load categories'));
      },
      (categories) {
        emit(CategoryLoaded(categories: categories));
      },
    );
  }
}
