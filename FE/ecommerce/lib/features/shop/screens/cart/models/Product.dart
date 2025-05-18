import 'package:ecommerce/features/shop/screens/cart/models/Variant.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final Variant variant;
  final String image;
  final double discount;
  int quantity = 1;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.image,
    required this.variant,
    required this.discount,
    this.quantity = 1,
  });

  Product copyWith({
    String? id,
    String? name,
    String? brand,
    String? category,
    double? price,
    String? description,
    String? image,
    Variant? variant,
    int? quantity,
    double? averageRating,
    int? totalReviews,
    double? discount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      image: image ?? this.image,
      variant: variant ?? this.variant,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
    );
  }

  factory Product.empty() {
    return Product(
      id: '',
      name: '',
      brand: '',
      category: '',
      image: '',
      variant: Variant.empty(),
      quantity: 0,
      discount: 0.0,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['_id'],
    name: json['name'],
    brand: json['brand'],
    category: json['category'],
    image: json['image'],
    variant: json['variant'],
    discount: (json['discount'] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'quantity': quantity,
      'image': image,
      'variant': variant,
    };
  }
}
