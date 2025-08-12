import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_manager.dart';
import '../models/book_model.dart';

abstract class GutenbergDataSource {
  Future<BookModel> downloadBook(String bookId);
}

@Injectable(as: GutenbergDataSource)
class GutenbergDataSourceImpl implements GutenbergDataSource {
  final ApiManager _apiManager;

  GutenbergDataSourceImpl(this._apiManager);

  @override
  Future<BookModel> downloadBook(String bookId) async {
    final url = '${ApiEndpoint.gutenbergContent}/$bookId/$bookId-0.txt';

    final rawText = await _apiManager.get<String>(
      url,
      fromJson: (data) => data as String,
    );

    return BookModel.fromGutenbergText(bookId, rawText);
  }
}
