import 'package:flutter/material.dart';

class SalesProvider extends ChangeNotifier {
  String _searchQuery = '';
  double _discount = 0.0;

  String get searchQuery => _searchQuery;
  double get discount => _discount;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateDiscount(double discount) {
    _discount = discount;
    notifyListeners();
  }

  void resetDiscount() {
    _discount = 0.0;
    notifyListeners();
  }
}
