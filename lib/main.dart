import 'package:flutter/material.dart';
import 'app.dart';
import 'injection_container.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await setupDependencyInjection();
  
  runApp(MyApp());
}