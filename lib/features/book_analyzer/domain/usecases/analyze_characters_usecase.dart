import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/error/failures.dart';
import '../entities/character_analysis.dart';
import '../repositories/book_analyzer_repository.dart';

@injectable
class AnalyzeCharactersUseCase {
  final BookAnalyzerRepository repository;

  AnalyzeCharactersUseCase(this.repository);

  Future<Either<Failure, CharacterAnalysis>> call({
    required String bookId,
    required String bookContent,
  }) async {
    return await repository.analyzeCharacters(bookId, bookContent);
  }
}
