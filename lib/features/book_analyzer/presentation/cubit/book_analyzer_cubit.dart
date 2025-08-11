import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/error_message_mapper.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/character_analysis.dart';
import '../../domain/usecases/download_book_usecase.dart';
import '../../domain/usecases/analyze_characters_usecase.dart';

part 'book_analyzer_state.dart';

@injectable
class BookAnalyzerCubit extends Cubit<BookAnalyzerState> {
  final DownloadBookUseCase _downloadBookUseCase;
  final AnalyzeCharactersUseCase _analyzeCharactersUseCase;

  BookAnalyzerCubit({
    required DownloadBookUseCase downloadBookUseCase,
    required AnalyzeCharactersUseCase analyzeCharactersUseCase,
  }) : _downloadBookUseCase = downloadBookUseCase,
       _analyzeCharactersUseCase = analyzeCharactersUseCase,
       super(const BookAnalyzerInitial());

  Future<void> analyzeBook(String bookId) async {
    if (bookId.trim().isEmpty) {
      emit(const BookAnalyzerError('Please enter a valid book ID'));
      return;
    }

    try {
      // Step 1: Download book
      emit(
        const BookAnalyzerLoading('Downloading book from Project Gutenberg...'),
      );

      final bookResult = await _downloadBookUseCase(bookId.trim());

      await bookResult.fold(
        (failure) async {
          // Convert technical failure to user-friendly message
          final userMessage = ErrorMessageMapper.getUserFriendlyMessage(
            failure,
          );
          emit(BookAnalyzerError(userMessage));
        },
        (book) async {
          emit(BookDownloaded(book));

          // Step 2: Analyze characters
          emit(const BookAnalyzerLoading('Analyzing characters with AI...'));

          final analysisResult = await _analyzeCharactersUseCase(
            bookId: book.id,
            bookContent: book.content,
          );

          analysisResult.fold(
            (failure) {
              // Convert technical failure to user-friendly message
              final userMessage = ErrorMessageMapper.getUserFriendlyMessage(
                failure,
              );
              emit(BookAnalyzerError(userMessage));
            },
            (analysis) {
              emit(CharacterAnalysisCompleted(book: book, analysis: analysis));
            },
          );
        },
      );
    } catch (e) {
      emit(BookAnalyzerError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  void reset() {
    emit(const BookAnalyzerInitial());
  }
}
