import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guten_read/features/category/presentation/cubit/category_cubit.dart';
import 'package:guten_read/features/category/presentation/pages/category_list_screen.dart';
import '../../features/product/presentation/cubit/product_list_cubit.dart';
import '../../features/product/presentation/pages/product_list_screen.dart';
import '../../injection_container.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<CategoryCubit>(),
            child: const CategoryListScreen(),
          ),
        );

      case ProductListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<ProductListCubit>(),
            child: const ProductListScreen(),
          ),
        );
      case CategoryListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<CategoryCubit>(),
            child: const CategoryListScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
           builder: (_) => BlocProvider(
            create: (context) => sl<ProductListCubit>(),
            child: const ProductListScreen(),
          ),
        );
    }
  }
}
