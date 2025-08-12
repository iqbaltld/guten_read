import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String appName = 'Gutenberg Character Analyzer';
  static String get groqApiKey => dotenv.env['GROQ_API_KEY']!;
  static const String defaultModel = 'llama3-8b-8192';
  static const int maxTokens = 2000;
  static const int textChunkSize = 8000; // Characters to analyze at once
}

class ApiEndpoint {
  static const String gutenbergContent = 'https://www.gutenberg.org/files';
  static const String groqApi =
      'https://api.groq.com/openai/v1/chat/completions';
}
