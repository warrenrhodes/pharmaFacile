import 'package:flutter/material.dart';

import 'utils.dart';

class DashboardController extends ChangeNotifier {
  DashboardStats _stats = DashboardStats.mock();

  DashboardStats get stats => _stats;

  /// Update dashboard statistics
  void updateStats(DashboardStats newStats) {
    _stats = newStats;
    notifyListeners();
  }

  /// Refresh dashboard data
  Future<void> refreshData() async {
    // For now, simulate loading
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }
}

class DashboardStats {
  final double todaysRevenue;
  final int todaysSalesCount;
  final int totalProducts;
  final List<LowStockProduct> lowStockProducts;

  const DashboardStats({
    required this.todaysRevenue,
    required this.todaysSalesCount,
    required this.totalProducts,
    required this.lowStockProducts,
  });

  /// Factory constructor for creating empty stats
  factory DashboardStats.empty() => const DashboardStats(
    todaysRevenue: 0.0,
    todaysSalesCount: 0,
    totalProducts: 0,
    lowStockProducts: [],
  );

  /// Factory constructor for creating mock data
  factory DashboardStats.mock() => const DashboardStats(
    todaysRevenue: 20000.0,
    todaysSalesCount: 2,
    totalProducts: 5,
    lowStockProducts: [
      LowStockProduct(name: 'Vitamine C 1000mg', quantity: 5),
      LowStockProduct(name: 'Antigrippal', quantity: 3),
      LowStockProduct(name: 'Paracétamol 500mg', quantity: 2),
    ],
  );

  bool get hasLowStock => lowStockProducts.isNotEmpty;
  int get lowStockCount => lowStockProducts.length;
}
