import 'package:flutter/foundation.dart';
import 'Product.dart';

class CartModel extends ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get items => _cartItems;
  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + item.price);

  void initialize(List<Product> products) {
    _cartItems.clear();
    _cartItems.addAll(products);
    notifyListeners();
  }

  void add(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clear() {
    _cartItems.clear();
    notifyListeners();
  }

  int getQuantity(Product product) {
    return _cartItems.where((item) => item == product).length;
  }
}
