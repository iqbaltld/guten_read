import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/product/presentation/cubit/product_list_cubit.dart';
import '../../features/product/presentation/pages/product_list_screen.dart';
import '../../injection_container.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<ProductListCubit>()..fetchInitial(),
            child: const ProductListScreen(),
          ),
        );

      case ProductListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<ProductListCubit>()..fetchInitial(),
            child: const ProductListScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<ProductListCubit>()..fetchInitial(),
            child: const ProductListScreen(),
          ),
        );
    }
  }
}