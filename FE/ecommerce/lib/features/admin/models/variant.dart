class Variant {
  final int id;
  final String color; // Màu sắc
  final String? ram; // RAM cho laptop
  final String? storage; // Bộ nhớ cho laptop
  final int stock;

  Variant({
    required this.id,
    required this.color,
    this.ram,
    this.storage,
    required this.stock,
  });
}