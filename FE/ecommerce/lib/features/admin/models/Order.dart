class Order {
  final String id;
  final DateTime createdAt;
  final String status;
  final List<OrderItem> items;
  final double subtotal;
  final double taxAmount;
  final double shippingFee;
  final double totalAmount;
  final Coupon? coupon;

  Order({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.shippingFee,
    required this.totalAmount,
    this.coupon,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: parseMongoId(json['_id']),
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'] ?? 'unknown',
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      coupon: json['coupon'] != null ? Coupon.fromJson(json['coupon']) : null,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String variantId;
  final int quantity;
  final double unitPrice;
  final double discountPerProduct;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.variantId,
    required this.quantity,
    required this.unitPrice,
    required this.discountPerProduct,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: parseMongoId(json['productId']),
      productName: json['productName'],
      variantId: json['variantId'],
      quantity: json['quantity'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      discountPerProduct: (json['discountPerProduct'] as num).toDouble(),
    );
  }
}

class Coupon {
  final String code;
  final double discountAmount;

  Coupon({required this.code, required this.discountAmount});

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      code: json['code'],
      discountAmount: (json['discountAmount'] as num).toDouble(),
    );
  }
}

String parseMongoId(dynamic id) {
  if (id is String) return id;
  if (id is Map<String, dynamic> && id.containsKey('\$oid')) return id['\$oid'];
  return id.toString();
}