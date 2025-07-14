import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:pharmacie_stock/models/category.dart';
import 'package:pharmacie_stock/models/product.dart';
import 'package:pharmacie_stock/models/supplier.dart';
import 'package:pharmacie_stock/models/transaction.dart';
import 'package:pharmacie_stock/utils/fake.dart';

import '../models/alert.dart';
import '../models/user.dart';

class AppProvider extends ChangeNotifier {
  final List<Product> _products = [];
  List<Alert> _alerts = [];
  final List<Category> _categories = [];
  final List<Supplier> _suppliers = [];
  final List<Transaction> _transactions = [];
  // final List<CartItem> _cart = [];
  bool _isLoading = false;

  List<Product> get products => fakeProducts;
  List<Category> get categories => fakeCategories;
  List<Supplier> get suppliers => fakeSuppliers;
  List<Transaction> get transactions => fakeTransactions;
  List<User> get users => fakeUsers;
  // List<CartItem> get cart => _cart;
  bool get isLoading => _isLoading;

  User? _currentUser;

  // Getters
  User? get currentUser => _currentUser;
  List<Alert> get alerts => _alerts;

  List<Alert> get unreadAlerts =>
      _alerts.where((alert) => !alert.read).toList();

  /// Adds an alert to the list
  void addAlert(Alert alert) {
    _alerts.insert(0, alert);
    notifyListeners();
  }

  /// Marks an alert as read
  void markAlertAsRead(String alertId) {
    final index = _alerts.indexWhere((alert) => alert.id == alertId);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(read: true);
      notifyListeners();
    }
  }

  /// Marks all alerts as read
  void markAllAlertsAsRead() {
    _alerts = _alerts.map((alert) => alert.copyWith(read: true)).toList();
    notifyListeners();
  }

  /// Sets loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      // final newTransaction = transaction.copyWith(
      //   id: _uuid.v4(),
      //   date: DateTime.now(),
      // );

      // await DatabaseService.instance.insertTransaction(newTransaction);
      // _transactions.insert(0, newTransaction);

      // // Update product quantity
      // if (transaction.type == TransactionType.sale) {
      //   final product = _products.firstWhere(
      //     (p) => p.id == transaction.productId,
      //   );
      //   final updatedProduct = product.copyWith(
      //     quantity: product.quantity - transaction.quantity,
      //     updatedAt: DateTime.now(),
      //   );
      //   await updateProduct(updatedProduct);
      // } else {
      //   final product = _products.firstWhere(
      //     (p) => p.id == transaction.productId,
      //   );
      //   final updatedProduct = product.copyWith(
      //     quantity: product.quantity + transaction.quantity,
      //     updatedAt: DateTime.now(),
      //   );
      //   await updateProduct(updatedProduct);
      // }

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  // Analytics
  List<Product> get lowStockProducts {
    return _products.where((p) => isLowStock(p)).toList();
  }

  List<Product> get expiringProducts {
    return _products.where((p) => isExpiringSoon(p)).toList();
  }

  bool isLowStock(Product product) =>
      product.quantity <= product.reorderThreshold;

  bool isExpiringSoon(Product product) {
    final thirtyDaysFromNow = clock.now().add(const Duration(days: 30));
    return product.expiryDate.isBefore(thirtyDaysFromNow) &&
        product.expiryDate.isAfter(DateTime.now());
  }

  double get todaysSales {
    final today = DateTime.now();
    return _transactions
        .where(
          (t) =>
              t.type == TransactionType.sale &&
              t.date.year == today.year &&
              t.date.month == today.month &&
              t.date.day == today.day,
        )
        .fold(0.0, (sum, t) => sum + t.total);
  }

  double get totalInventoryValue {
    return _products.fold(0.0, (sum, p) => sum + (p.price * p.quantity));
  }
}
