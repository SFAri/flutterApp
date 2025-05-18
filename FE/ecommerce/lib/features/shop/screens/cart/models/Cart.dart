import 'package:ecommerce/utils/helpers/pricing_calculator.dart';
import 'package:flutter/foundation.dart';
import 'Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartModel extends ChangeNotifier {
  final List<Product> _cartItems = [];
  static const String _cartKey = 'cartItems';

  // Constructor to load cart data when the model is initialized
  CartModel() {
    loadCartFromStorage();
  }

  List<Product> get items => _cartItems;

  double get totalPrice => _cartItems.fold(
    0.0,
    (sum, item) =>
        sum +
        (CPricingCalculator.calculateDiscount(
              item.variant.salePrice,
              item.discount,
            ) *
            item.quantity),
  );

  Future<void> loadCartFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString(_cartKey);
    if (cartString != null) {
      final List<dynamic> cartJson = json.decode(cartString);
      _cartItems.clear();
      _cartItems.addAll(
        cartJson.map((itemJson) => Product.fromJson(itemJson)).toList(),
      );
      notifyListeners();
    }
  }

  Future<void> _saveCartToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _cartItems.map((item) => item.toJson()).toList();
    prefs.setString(_cartKey, json.encode(cartJson));
  }

  void add(Product product) {
    _cartItems.add(product);
    notifyListeners();
    _saveCartToStorage();
  }

  void remove(Product product) {
    _cartItems.remove(product);
    notifyListeners();
    _saveCartToStorage();
  }

  void addItem(Product product) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.id == product.id,
    );
    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity++;
    } else {
      _cartItems.add(product.copyWith(quantity: 1));
    }
    notifyListeners();
    _saveCartToStorage();
  }

  void removeItem(Product product) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.id == product.id,
    );
    if (existingItemIndex != -1) {
      if (_cartItems[existingItemIndex].quantity > 1) {
        _cartItems[existingItemIndex].quantity--;
      } else {
        _cartItems.removeAt(existingItemIndex);
      }
      notifyListeners();
      _saveCartToStorage();
    }
  }

  void clear() {
    _cartItems.clear();
    notifyListeners();
    _saveCartToStorage();
  }

  int getQuantity(Product product) {
    final match = _cartItems.firstWhere(
      (item) => item.id == product.id,
      orElse: () => Product.empty(),
    );
    return match.quantity;
  }

  void incrementQuantity(Product product) {
    final match = _cartItems.firstWhere((item) => item.id == product.id);
    match.quantity++;
    notifyListeners();
    _saveCartToStorage();
  }

  void decrementQuantity(Product product) {
    final match = _cartItems.firstWhere((item) => item.id == product.id);
    match.quantity--;
    notifyListeners();
    _saveCartToStorage();
  }
}
