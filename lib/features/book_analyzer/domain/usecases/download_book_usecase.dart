import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/error/failures.dart';
import '../entities/book.dart';
import '../repositories/book_analyzer_repository.dart';

@injectable
class DownloadBookUseCase {
  final BookAnalyzerRepository repository;

  DownloadBookUseCase(this.repository);

  Future<Either<Failure, Book>> call(String bookId) async {
    return await repository.downloadBook(bookId);
  }
}