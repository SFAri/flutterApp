class Product {
  final String name;
  final String image;
  final double price;
  final String description;
  int quantity;

  Product(
      {required this.name,
      required this.image,
      required this.price,
      required this.description,
      this.quantity = 1});
}
