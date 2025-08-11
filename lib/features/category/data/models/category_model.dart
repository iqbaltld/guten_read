import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required String slug,
    required String name,
    required String url,
  }) : super(
          slug: slug,
          name: name,
          url: url,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      slug: json['slug'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}
