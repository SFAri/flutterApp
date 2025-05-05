import 'package:ecommerce/features/admin/models/variation_attribute_option.dart';

class Variation {
  final int id;
  final int productId;
  final double importPrice;
  final double salePrice;
  final double discountPercent;
  final List<VariationAttributeOption> options;

  Variation({
    required this.id,
    required this.productId,
    required this.importPrice,
    required this.salePrice,
    required this.discountPercent,
    required this.options,
  });

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
    id: json['id'],
    productId: json['productId'],
    importPrice: json['importPrice'].toDouble(),
    salePrice: json['salePrice'].toDouble(),
    discountPercent: json['discountPercent'].toDouble(), 
    options: (json['options'] as List<dynamic>)
        .map((v) => VariationAttributeOption.fromJson(v))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'importPrice': importPrice,
    'salePrice': salePrice,
    'discountPercent': discountPercent,
    'options' : options
  };
}
