import 'package:flutter/material.dart';


class NavigationService extends RouteObserver<ModalRoute<dynamic>> {
  final GlobalKey<NavigatorState> navigatorKey;
  
  NavigationService({required this.navigatorKey});

  String? get currentRoute {
    String? currentPath;
    navigatorKey.currentState?.popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    return currentPath;
  }

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateAndClearStack(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  void goBack([dynamic result]) {
    return navigatorKey.currentState!.pop(result);
  }

  bool canGoBack() {
    return navigatorKey.currentState!.canPop();
  }
}