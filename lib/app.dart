import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guten_read/features/book_analyzer/presentation/cubit/book_analyzer_cubit.dart';
import 'core/routes/app_router.dart';
import 'injection_container.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926), // Mobile-focused design
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [BlocProvider(create: (_) => sl<BookAnalyzerCubit>())],
          child: Builder(
            builder: (context) {
              return MaterialApp(
                title: 'Gutenberg Character Analyzer',

                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  useMaterial3: true,
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  cardTheme: CardThemeData(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
