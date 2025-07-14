import 'package:flutter/material.dart';

import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  double get cartTotal {
    return _cart.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  // Cart operations
  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = _cart.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      final existingItem = _cart[existingIndex];
      if (existingItem.quantity + quantity <= product.quantity) {
        _cart[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
      }
    } else {
      if (quantity <= product.quantity) {
        _cart.add(CartItem(product: product, quantity: quantity));
      }
    }
    notifyListeners();
  }

  void updateCartQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      _cart.removeWhere((item) => item.product.id == productId);
    } else {
      final index = _cart.indexWhere((item) => item.product.id == productId);
      if (index != -1) {
        final product = _cart[index].product;
        if (quantity <= product.quantity) {
          _cart[index] = _cart[index].copyWith(quantity: quantity);
        }
      }
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get total => product.price * quantity;
}
