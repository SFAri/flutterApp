import 'package:ecommerce/features/admin/models/variant.dart';

// Thông tin trong các textfield gồm: ID, Code, name, description, imageStrings[], brand, category, discount
// Dưới là 1 cái listview động chứa thông tin variants: [code, name, type ,retail price, sale price, inStock]
class Product {
  final int id;
  final String? code;
  final String name;
  final String description;
  final List<String> imageStrings;
  final int brandId;
  final int categoryId;
  final double discount;

  final List<Variant>? variants; // Trường variants có thể là null

  Product({required this.id, required this.name, this.code, required this.description, required this.imageStrings, required this.brandId, required this.categoryId, required this.discount,  this.variants});
}