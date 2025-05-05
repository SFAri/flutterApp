import 'package:ecommerce/features/admin/models/variant.dart';
class Product {
  final int id;
  final String name;
  final String description;
  final List<String> image;
  final int categoryId;
  final int brandId;
  final List<Variation> variations;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.categoryId,
    required this.brandId,
    required this.variations,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    image: List<String>.from(json['image']),
    categoryId: json['categoryId'],
    brandId: json['brandId'],
    variations: (json['variations'] as List<dynamic>)
        .map((v) => Variation.fromJson(v))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image': image,
    'categoryId': categoryId,
    'variations': variations.map((v) => v.toJson()).toList(),
  };
}
