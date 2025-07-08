import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';
import '../models/sale_item_model.dart';

class CartNotifier extends StateNotifier<List<SaleItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product, int quantity) {
    final existingItemIndex = state.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingItemIndex != -1) {
      // Update existing item
      final existingItem = state[existingItemIndex];
      final newQuantity = existingItem.quantity + quantity;

      if (newQuantity > product.stock) {
        throw Exception('Stock insuffisant pour cette quantité totale');
      }

      final updatedItem = existingItem.copyWith(
        quantity: newQuantity,
        total: newQuantity * product.sellingPrice,
      );

      state = [
        ...state.sublist(0, existingItemIndex),
        updatedItem,
        ...state.sublist(existingItemIndex + 1),
      ];
    } else {
      // Add new item
      final newItem = SaleItem(
        productId: product.id,
        productName: product.name,
        quantity: quantity,
        unitPrice: product.sellingPrice,
        total: quantity * product.sellingPrice,
      );

      state = [...state, newItem];
    }
  }

  void removeFromCart(String productId) {
    state = state.where((item) => item.productId != productId).toList();
  }

  void clearCart() {
    state = [];
  }

  double get totalAmount {
    return state.fold(0.0, (sum, item) => sum + item.total);
  }

  int get itemCount {
    return state.length;
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<SaleItem>>(
  (ref) => CartNotifier(),
);

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (sum, item) => sum + item.total);
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.length;
});
