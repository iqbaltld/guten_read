class AppConstants {
  static const String appName = 'Guten Read';
  static const String baseUrl = 'https://www.gutenberg.org';
}

class ApiEndpoint {
  static String contentUrl(String bookId) => '/files/$bookId/$bookId-0.txt';
  static String metadataUrl(String bookId) => '/ebooks/$bookId';
}
