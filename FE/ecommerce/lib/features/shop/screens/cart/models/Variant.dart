import 'package:ecommerce/features/shop/screens/cart/models/Specs.dart';

class Variant {
  final String variantId;
  final String type;
  final Specs specs;
  final String color;
  final int inventory;
  final double salePrice;

  Variant({
    required this.variantId,
    required this.type,
    required this.specs,
    required this.color,
    required this.inventory,
    required this.salePrice,
  });

  factory Variant.empty() {
    return Variant(
      variantId: '',
      type: '',
      specs: Specs(),
      color: '',
      inventory: 0,
      salePrice: 0.0,
    );
  }

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    variantId: json['variantId'],
    type: json['type'],
    specs: Specs.fromJson(json['specs']),
    color: json['color'],
    inventory: json['inventory'],
    salePrice: (json['salePrice'] ?? 0).toDouble(),
  );

  Map<String, dynamic> tojson() {
    return {
      'variantId': variantId,
      'type': type,
      'specs': specs.toJson(),
      'color': color,
      'inventory': inventory,
      'salePrice': salePrice,
    };
  }
}
