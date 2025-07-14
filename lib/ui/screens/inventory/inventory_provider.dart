import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:pharmacie_stock/models/product.dart';

/// Provider for managing inventory UI state
class InventoryProvider with ChangeNotifier {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all';

  /// Controller for search input
  TextEditingController get searchController => _searchController;

  /// Current search query
  String get searchQuery => _searchQuery;

  /// Currently selected category ID
  String get selectedCategory => _selectedCategory;

  InventoryProvider() {
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchQuery != _searchController.text) {
      _searchQuery = _searchController.text;
      notifyListeners();
    }
  }

  /// Updates the search query
  void updateSearchQuery(String? query) {
    if (query != null && query != _searchQuery) {
      _searchQuery = query;
      _searchController.text = query;
      notifyListeners();
    }
  }

  /// Updates the selected category
  void updateSelectedCategory(String? categoryId) {
    if (categoryId != null && categoryId != _selectedCategory) {
      _selectedCategory = categoryId;
      notifyListeners();
    }
  }

  /// Clears all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'all';
    _searchController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool isLowStock(Product product) =>
      product.quantity <= product.reorderThreshold;

  bool isExpiringSoon(Product product) {
    final thirtyDaysFromNow = clock.now().add(const Duration(days: 30));
    return product.expiryDate.isBefore(thirtyDaysFromNow) &&
        product.expiryDate.isAfter(DateTime.now());
  }
}
