import 'package:guten_read/features/book_analyzer/domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.content,
    required super.contentLength,
  });

  // Simplified factory - just extract content, let AI handle title/author
  factory BookModel.fromGutenbergText(String bookId, String rawText) {
    final lines = rawText.split('\n');

    // Find content boundaries
    int contentStart = 0;
    int contentEnd = lines.length;

    // Find start marker
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains('*** START OF') &&
          lines[i].contains('PROJECT GUTENBERG')) {
        contentStart = i + 1;
        break;
      }
    }

    // Find end marker
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
      title: 'Extracting...', // Placeholder - AI will determine this
      author: 'Extracting...', // Placeholder - AI will determine this
      content: content,
      contentLength: content.length,
    );
  }
}
