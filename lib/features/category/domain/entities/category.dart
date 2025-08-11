import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String slug;
  final String name;
  final String url;

  const Category({
    required this.slug,
    required this.name,
    required this.url,
  });

  @override
  List<Object> get props => [slug, name, url];

  @override
  String toString() => 'Category(slug: $slug, name: $name, url: $url)';
}
