import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/base_repository.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/character_analysis.dart';
import '../../domain/repositories/book_analyzer_repository.dart';
import '../datasources/gutenberg_data_source.dart';
import '../datasources/llm_data_source.dart';

@Injectable(as: BookAnalyzerRepository)
class BookAnalyzerRepositoryImpl implements BookAnalyzerRepository {
  final GutenbergDataSource _gutenbergDataSource;
  final LLMDataSource _llmDataSource;
  final BaseRepository _baseRepository;

  BookAnalyzerRepositoryImpl(
    this._gutenbergDataSource,
    this._llmDataSource,
    this._baseRepository,
  );

  @override
  Future<Either<Failure, Book>> downloadBook(String bookId) async {
    return await _baseRepository.handleApiCall<Book>(
      call: () => _gutenbergDataSource.downloadBook(bookId),
      onSuccess: (response) => response,
      context: 'DownloadBook',
    );
  }

  @override
  Future<Either<Failure, CharacterAnalysis>> analyzeCharacters(
    String bookId,
    String bookContent,
  ) async {
    return await _baseRepository.handleApiCall<CharacterAnalysis>(
      call: () => _llmDataSource.analyzeCharacters(
        bookId: bookId,
        bookTitle: 'Book $bookId', // This will be updated with actual title
        content: bookContent,
      ),
      onSuccess: (response) => response,
      context: 'AnalyzeCharacters',
    );
  }
}