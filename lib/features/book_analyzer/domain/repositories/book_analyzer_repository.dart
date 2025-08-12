import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failures.dart';
import '../entities/book.dart';
import '../entities/character_analysis.dart';

abstract class BookAnalyzerRepository {
  Future<Either<Failure, Book>> downloadBook(String bookId);
  Future<Either<Failure, CharacterAnalysis>> analyzeCharacters(
    String bookId,
    String bookContent,
  );
}
