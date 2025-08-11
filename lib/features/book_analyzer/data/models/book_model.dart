import 'package:guten_read/features/book_analyzer/domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.content,
    required super.contentLength,
  });

  factory BookModel.fromGutenbergText(String bookId, String rawText) {
    // Parse Project Gutenberg text format
    final lines = rawText.split('\n');
    String title = 'Unknown Title';
    String author = 'Unknown Author';

    // Extract title and author from header
    for (int i = 0; i < 50 && i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.toLowerCase().contains('title:')) {
        title = line
            .replaceFirst(RegExp(r'title:\s*', caseSensitive: false), '')
            .trim();
      } else if (line.toLowerCase().contains('author:')) {
        author = line
            .replaceFirst(RegExp(r'author:\s*', caseSensitive: false), '')
            .trim();
      }
    }

    // Find start of actual content (after *** START OF [THE] PROJECT GUTENBERG EBOOK ***)
    int contentStart = 0;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains('*** START OF') &&
          lines[i].contains('PROJECT GUTENBERG')) {
        contentStart = i + 1;
        break;
      }
    }

    // Find end of content (before *** END OF [THE] PROJECT GUTENBERG EBOOK ***)
    int contentEnd = lines.length;
    for (int i = contentStart; i < lines.length; i++) {
      if (lines[i].contains('*** END OF') &&
          lines[i].contains('PROJECT GUTENBERG')) {
        contentEnd = i;
        break;
      }
    }

    final content = lines.sublist(contentStart, contentEnd).join('\n').trim();

    return BookModel(
      id: bookId,
      title: title,
      author: author,
      content: content,
      contentLength: content.length,
    );
  }
}
