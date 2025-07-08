import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';

final productServiceProvider =
    Provider<ProductService>((ref) => ProductService());

final productsStreamProvider = StreamProvider<List<Product>>((ref) {
  final service = ref.watch(productServiceProvider);
  return service.getProductsStream();
});

class ProductListNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductService _service;
  ProductListNotifier(this._service) : super(const AsyncValue.loading()) {
    _service.getProductsStream().listen((products) {
      state = AsyncValue.data(products);
    });
  }

  Future<void> addProduct(Product product) async {
    await _service.addProduct(product);
  }

  Future<void> updateProduct(Product product) async {
    await _service.updateProduct(product);
  }

  Future<void> deleteProduct(String productId) async {
    await _service.deleteProduct(productId);
  }
}

final productListProvider =
    StateNotifierProvider<ProductListNotifier, AsyncValue<List<Product>>>(
        (ref) {
  final service = ref.watch(productServiceProvider);
  return ProductListNotifier(service);
});
