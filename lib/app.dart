import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routes/app_router.dart';
import 'core/services/navigation_service.dart';
import 'features/product/presentation/cubit/product_list_cubit.dart';
import 'injection_container.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<ProductListCubit>(),
            ),
          ],
          child: Builder(
            builder: (context) {
              final navigationService = sl<NavigationService>();
              return MaterialApp(
                title: 'Products App',
                navigatorKey: navigationService.navigatorKey,
                navigatorObservers: [navigationService],
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  useMaterial3: true,
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                ),
                onGenerateRoute: _appRouter.onGenerateRoute,
              );
            },
          ),
        );
      },
    );
  }
}