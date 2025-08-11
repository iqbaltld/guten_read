import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<String>>> getCategories();
}
