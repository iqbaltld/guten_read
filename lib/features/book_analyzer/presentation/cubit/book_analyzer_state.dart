part of 'book_analyzer_cubit.dart';

sealed class BookAnalyzerState extends Equatable {
  const BookAnalyzerState();

  @override
  List<Object?> get props => [];
}

class BookAnalyzerInitial extends BookAnalyzerState {
  const BookAnalyzerInitial();
}

class BookAnalyzerLoading extends BookAnalyzerState {
  final String message;

  const BookAnalyzerLoading(this.message);

  @override
  List<Object> get props => [message];
}

class BookDownloaded extends BookAnalyzerState {
  final Book book;

  const BookDownloaded(this.book);

  @override
  List<Object> get props => [book];
}

class CharacterAnalysisCompleted extends BookAnalyzerState {
  final Book book;
  final CharacterAnalysis analysis;

  const CharacterAnalysisCompleted({
    required this.book,
    required this.analysis,
  });

  @override
  List<Object> get props => [book, analysis];
}

class BookAnalyzerError extends BookAnalyzerState {
  final String message;

  const BookAnalyzerError(this.message);

  @override
  List<Object> get props => [message];
}