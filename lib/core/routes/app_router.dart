import 'package:flutter/material.dart';
import 'package:guten_read/features/book_analyzer/presentation/pages/book_analyzer_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const BookAnalyzerScreen());

      case BookAnalyzerScreen.routeName:
        return MaterialPageRoute(builder: (_) => const BookAnalyzerScreen());

      default:
        return MaterialPageRoute(builder: (_) => const BookAnalyzerScreen());
    }
  }
}
