import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String content;
  final int contentLength;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
    required this.contentLength,
  });

  @override
  List<Object> get props => [id, title, author, content, contentLength];
}