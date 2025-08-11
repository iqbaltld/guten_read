import 'dart:math' as math;

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
    // First try specific parsing for known books
    if (bookId == '1513' || rawText.contains('ROMEO AND JULIET')) {
      return _parseRomeoAndJuliet(bookId, rawText);
    } else if (bookId == '11' || rawText.contains('ALICE')) {
      return _parseAliceInWonderland(bookId, rawText);
    } else if (bookId == '1342' || rawText.contains('PRIDE AND PREJUDICE')) {
      return _parsePrideAndPrejudice(bookId, rawText);
    } else if (bookId == '1524' || rawText.contains('HAMLET')) {
      return _parseHamlet(bookId, rawText);
    }
    
    // Fallback to generic parsing
    return _parseGeneric(bookId, rawText);
  }

  // Enhanced factory with fallback
  factory BookModel.fromGutenbergTextWithFallback(String bookId, String rawText) {
    final knownBooks = _getKnownBooks();
    
    // Try parsing first
    final parsed = BookModel.fromGutenbergText(bookId, rawText);
    
    // If we got "Unknown Title" and we know this book, use known data
    if (parsed.title == 'Unknown Title' && knownBooks.containsKey(bookId)) {
      final bookInfo = knownBooks[bookId]!;
      final boundaries = _findContentBoundaries(rawText.split('\n'));
      final lines = rawText.split('\n');
      final content = lines.sublist(boundaries.start, boundaries.end).join('\n').trim();
      
      return BookModel(
        id: bookId,
        title: bookInfo.title,
        author: bookInfo.author,
        content: content,
        contentLength: content.length,
      );
    }
    
    return parsed;
  }

  // Specific parser for Romeo and Juliet
  static BookModel _parseRomeoAndJuliet(String bookId, String rawText) {
    final lines = rawText.split('\n');
    String title = 'The Tragedy of Romeo and Juliet';
    String author = 'William Shakespeare';

    // Find content boundaries
    final boundaries = _findContentBoundaries(lines);
    
    // Look for title and author in the early content
    for (int i = boundaries.start; i < math.min(boundaries.start + 20, lines.length); i++) {
      final line = lines[i].trim();
      
      if (line.toUpperCase().contains('TRAGEDY OF ROMEO AND JULIET') ||
          line.toUpperCase().contains('ROMEO AND JULIET')) {
        title = 'The Tragedy of Romeo and Juliet';
      }
      
      if (line.toLowerCase().contains('william shakespeare') ||
          line.toLowerCase().contains('by william shakespeare')) {
        author = 'William Shakespeare';
      }
    }

    final content = lines.sublist(boundaries.start, boundaries.end).join('\n').trim();
    
    return BookModel(
      id: bookId,
      title: title,
      author: author,
      content: content,
      contentLength: content.length,
    );
  }

  // Other specific parsers...
  static BookModel _parseAliceInWonderland(String bookId, String rawText) {
    final boundaries = _findContentBoundaries(rawText.split('\n'));
    final lines = rawText.split('\n');
    final content = lines.sublist(boundaries.start, boundaries.end).join('\n').trim();
    
    return BookModel(
      id: bookId,
      title: "Alice's Adventures in Wonderland",
      author: 'Lewis Carroll',
      content: content,
      contentLength: content.length,
    );
  }

  static BookModel _parsePrideAndPrejudice(String bookId, String rawText) {
    final boundaries = _findContentBoundaries(rawText.split('\n'));
    final lines = rawText.split('\n');
    final content = lines.sublist(boundaries.start, boundaries.end).join('\n').trim();
    
    return BookModel(
      id: bookId,
      title: 'Pride and Prejudice',
      author: 'Jane Austen',
      content: content,
      contentLength: content.length,
    );
  }

  static BookModel _parseHamlet(String bookId, String rawText) {
    final boundaries = _findContentBoundaries(rawText.split('\n'));
    final lines = rawText.split('\n');
    final content = lines.sublist(boundaries.start, boundaries.end).join('\n').trim();
    
    return BookModel(
      id: bookId,
      title: 'The Tragedy of Hamlet, Prince of Denmark',
      author: 'William Shakespeare',
      content: content,
      contentLength: content.length,
    );
  }

  // Generic parser for unknown books
  static BookModel _parseGeneric(String bookId, String rawText) {
    final lines = rawText.split('\n');
    String title = 'Unknown Title';
    String author = 'Unknown Author';

    final boundaries = _findContentBoundaries(lines);

    // Look for title and author in header and early content
    for (int i = 0; i < math.min(boundaries.start + 30, lines.length); i++) {
      final line = lines[i].trim();
      
      // Skip empty lines and very short lines
      if (line.isEmpty || line.length < 3) continue;
      
      // Look for title patterns
      if (_isLikelyTitle(line) && title == 'Unknown Title') {
        title = _cleanTitle(line);
      }
      
      // Look for author patterns
      if (_isLikelyAuthor(line) && author == 'Unknown Author') {
        author = _cleanAuthor(line);
      }
    }

    final content = lines.sublist(boundaries.start, boundaries.end).join('\n').trim();
    
    return BookModel(
      id: bookId,
      title: title,
      author: author,
      content: content,
      contentLength: content.length,
    );
  }

  // Helper to find content boundaries
  static ({int start, int end}) _findContentBoundaries(List<String> lines) {
    int contentStart = 0;
    int contentEnd = lines.length;

    // Find start
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains('*** START OF') && lines[i].contains('PROJECT GUTENBERG')) {
        contentStart = i + 1;
        break;
      }
    }

    // Find end
    for (int i = contentStart; i < lines.length; i++) {
      if (lines[i].contains('*** END OF') && lines[i].contains('PROJECT GUTENBERG')) {
        contentEnd = i;
        break;
      }
    }

    return (start: contentStart, end: contentEnd);
  }

  // Pattern matching helpers
  static bool _isLikelyTitle(String line) {
    final cleanLine = line.toLowerCase().trim();
    
    if (cleanLine.contains('project gutenberg') ||
        cleanLine.contains('ebook') ||
        cleanLine.contains('***') ||
        cleanLine.contains('produced by') ||
        cleanLine.length < 5 ||
        cleanLine.length > 80) {
      return false;
    }

    return cleanLine.startsWith('title:') ||
           cleanLine.contains('title:') ||
           (line.length > 10 && line.length < 60 && line == line.toUpperCase());
  }

  static bool _isLikelyAuthor(String line) {
    final cleanLine = line.toLowerCase().trim();
    
    if (cleanLine.isEmpty || line.length > 50 || line.length < 5) return false;
    
    return cleanLine.startsWith('author:') ||
           cleanLine.startsWith('by ') ||
           cleanLine.contains('author:') ||
           _containsAuthorPatterns(line);
  }

  static bool _containsAuthorPatterns(String line) {
    final famousAuthors = [
      'shakespeare', 'dickens', 'austen', 'carroll', 'wilde', 'swift',
      'defoe', 'shelley', 'stoker', 'verne', 'dumas', 'hugo', 'tolstoy',
      'twain', 'melville', 'hawthorne', 'poe', 'alcott', 'london'
    ];
    
    final lowerLine = line.toLowerCase();
    return famousAuthors.any((author) => lowerLine.contains(author));
  }

  static String _cleanTitle(String title) {
    return title
        .replaceAll(RegExp(r'^title:\s*', caseSensitive: false), '')
        .replaceAll(RegExp(r'^the\s+', caseSensitive: false), 'The ')
        .trim();
  }

  static String _cleanAuthor(String author) {
    return author
        .replaceAll(RegExp(r'^author:\s*', caseSensitive: false), '')
        .replaceAll(RegExp(r'^by\s+', caseSensitive: false), '')
        .trim();
  }

  // Known books database
  static Map<String, ({String title, String author})> _getKnownBooks() {
    return {
      '1513': (title: 'The Tragedy of Romeo and Juliet', author: 'William Shakespeare'),
      '1524': (title: 'The Tragedy of Hamlet, Prince of Denmark', author: 'William Shakespeare'),
      '11': (title: "Alice's Adventures in Wonderland", author: 'Lewis Carroll'),
      '1342': (title: 'Pride and Prejudice', author: 'Jane Austen'),
      '74': (title: 'The Adventures of Tom Sawyer', author: 'Mark Twain'),
      '84': (title: 'Frankenstein', author: 'Mary Wollstonecraft Shelley'),
      '174': (title: 'The Picture of Dorian Gray', author: 'Oscar Wilde'),
      '345': (title: 'Dracula', author: 'Bram Stoker'),
      '1661': (title: 'The Adventures of Sherlock Holmes', author: 'Arthur Conan Doyle'),
      '2701': (title: 'Moby Dick', author: 'Herman Melville'),
      '1232': (title: 'The Prince', author: 'Niccolò Machiavelli'),
      '76': (title: 'Adventures of Huckleberry Finn', author: 'Mark Twain'),
      '1184': (title: 'The Count of Monte Cristo', author: 'Alexandre Dumas'),
      '98': (title: 'A Tale of Two Cities', author: 'Charles Dickens'),
      '1400': (title: 'Great Expectations', author: 'Charles Dickens'),
    };
  }
}