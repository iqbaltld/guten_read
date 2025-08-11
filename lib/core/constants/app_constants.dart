class AppConstants {
  static const String appName = 'Gutenberg Character Analyzer';
  static const String groqApiKey =
      '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';
  static const String defaultModel = 'llama3-8b-8192';
  static const int maxTokens = 2000;
  static const int textChunkSize = 8000; // Characters to analyze at once
}

class ApiEndpoint {
  static const String gutenbergContent = 'https://www.gutenberg.org/files';
  static const String groqApi =
      'https://api.groq.com/openai/v1/chat/completions';
}
