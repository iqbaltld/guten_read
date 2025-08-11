import 'package:guten_read/features/book_analyzer/data/models/character_model.dart';
import 'package:guten_read/features/book_analyzer/domain/entities/character_analysis.dart';

class CharacterAnalysisModel extends CharacterAnalysis {
  const CharacterAnalysisModel({
    required super.bookId,
    required super.bookTitle,
    required super.characters,
    required super.analyzedAt,
    super.summary,
  });

  factory CharacterAnalysisModel.fromJson(Map<String, dynamic> json) {
    return CharacterAnalysisModel(
      bookId: json['book_id'] as String,
      bookTitle: json['book_title'] as String,
      characters: (json['characters'] as List<dynamic>)
          .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      analyzedAt: DateTime.parse(json['analyzed_at'] as String),
      summary: json['summary'] as String?,
    );
  }
}
