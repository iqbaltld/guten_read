import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_constants.dart';
import 'core/network/custom_interceptor.dart';
import 'core/services/navigation_service.dart';
import 'injection_container.config.dart';

/// Global service locator instance
final GetIt sl = GetIt.instance;

/// Configures and initializes all generated dependencies using injectable.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => sl.init();

/// Sets up and configures all dependencies for the application.
Future<void> setupDependencyInjection() async {
  // 1. Register core services first
  await _registerCoreServices();

  // 2. Register navigation dependencies
  _registerNavigationDependencies();
  
  // 3. Register network-related dependencies
  _registerNetworkDependencies();
  
  // 4. Initialize generated dependencies last
  configureDependencies();
}

/// Registers core services like SharedPreferences and Connectivity
Future<void> _registerCoreServices() async {
  // Initialize and register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Register Connectivity for network status
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
}

/// Registers network-related dependencies including Dio and interceptors
void _registerNetworkDependencies() {
  // Configure Dio with base options
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
      baseUrl: AppConstants.baseUrl,
    ),
  );

  // Register Dio as a singleton
  sl.registerLazySingleton<Dio>(() => dio);

  // Register and configure interceptors
  final customInterceptor = CustomInterceptor(
    sl<SharedPreferences>(),
    sl<NavigationService>(),
  );

  sl.registerLazySingleton<CustomInterceptor>(() => customInterceptor);

  // Add interceptors to Dio instance
  dio.interceptors.addAll([
    customInterceptor,
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      logPrint: (obj) => debugPrint(obj.toString()),
    ),
  ]);
}

/// Registers navigation-related dependencies
void _registerNavigationDependencies() {
  // Register navigation key
  sl.registerLazySingleton<GlobalKey<NavigatorState>>(
    () => GlobalKey<NavigatorState>(),
  );

  // Register navigation service with navigatorKey parameter
  sl.registerLazySingleton<NavigationService>(
    () => NavigationService(navigatorKey: sl<GlobalKey<NavigatorState>>()),
  );
}