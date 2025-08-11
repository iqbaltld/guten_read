class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Server error', this.statusCode});

  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'Network error'});

  @override
  String toString() => 'NetworkException: $message';
}

class LLMException implements Exception {
  final String message;

  const LLMException({this.message = 'LLM processing error'});

  @override
  String toString() => 'LLMException: $message';
}
