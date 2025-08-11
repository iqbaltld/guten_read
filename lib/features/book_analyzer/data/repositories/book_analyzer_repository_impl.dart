import 'package:dartz/dartz.dart';
import 'package:guten_read/features/book_analyzer/data/models/book_model.dart';
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
  final LLMDataSource _llmDataSource; // Updated interface name
  final BaseRepository _baseRepository;

  BookAnalyzerRepositoryImpl(
    this._gutenbergDataSource,
    this._llmDataSource,
    this._baseRepository,
  );

  @override
  Future<Either<Failure, Book>> downloadBook(String bookId) async {
    return await _baseRepository.handleApiCall<Book>(
      call: () async {
        // Step 1: Download raw book content
        final bookModel = await _gutenbergDataSource.downloadBook(bookId);

        // Step 2: Extract title and author using AI
        final bookInfo = await _llmDataSource.extractBookInfo(
          content: bookModel.content,
        );

        // Step 3: Return complete book with AI-extracted info
        return BookModel(
          id: bookModel.id,
          title: bookInfo.title,
          author: bookInfo.author,
          content: bookModel.content,
          contentLength: bookModel.contentLength,
        );
      },
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
        bookTitle:
            'Book Analysis', // You could pass the actual title here if needed
        content: bookContent,
      ),
      onSuccess: (response) => response,
      context: 'AnalyzeCharacters',
    );
  }
}
