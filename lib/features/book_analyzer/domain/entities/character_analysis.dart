import 'package:equatable/equatable.dart';
import 'character.dart';

class CharacterAnalysis extends Equatable {
  final String bookId;
  final String bookTitle;
  final List<Character> characters;
  final DateTime analyzedAt;
  final String? summary;

  const CharacterAnalysis({
    required this.bookId,
    required this.bookTitle,
    required this.characters,
    required this.analyzedAt,
    this.summary,
  });

  @override
  List<Object?> get props => [bookId, bookTitle, characters, analyzedAt, summary];
}