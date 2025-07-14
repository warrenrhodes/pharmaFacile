import 'package:flutter/material.dart';
import 'package:pharmacie_stock/config/internationalizations/internationalization.dart';
import 'package:pharmacie_stock/models/transaction.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/utils/app_colors.dart';
import 'package:pharmacie_stock/utils/fake.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../utils/currency_formatter.dart';
import 'stat_card.dart';

/// Dashboard statistics widget that displays key metrics in a grid layout.
class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final stats = _calculateStats(appProvider);

        final statsCard = [
          StatCard(
            title: 'Total Products',
            value: stats.totalProducts.toString(),
            icon: LucideIcons.package400,
            color: AppColors.cobalt,
            change: '+12% from last month',
            trend: TrendType.up,
          ),
          StatCard(
            title: 'Low Stock Items',
            value: stats.lowStockItems.toString(),
            icon: LucideIcons.triangleAlert400,
            color: AppColors.red,
            change: stats.lowStockItems > 0 ? 'Requires attention' : 'All good',
            trend: stats.lowStockItems > 0 ? TrendType.down : TrendType.neutral,
          ),
          StatCard(
            title: 'Expiring Soon',
            value: stats.expiringItems.toString(),
            icon: LucideIcons.calendar400,
            color: AppColors.warningColor,
            change: 'Next 30 days',
            trend: TrendType.neutral,
          ),
          StatCard(
            title: 'Today\'s Sales',
            value: CurrencyFormatter.formatCurrency(
              stats.todaySales,
              context.watch<Internationalization>().locale,
            ),
            icon: LucideIcons.wallet400,
            color: AppColors.lightGreen,
            change: '+8% from yesterday',
            trend: TrendType.up,
          ),
          StatCard(
            title: 'Today\'s Transactions',
            value: stats.todayTransactions.toString(),
            icon: LucideIcons.shoppingCart400,
            color: AppColors.purple,
            change: '+5% from yesterday',
            trend: TrendType.up,
          ),
          StatCard(
            title: 'Total Suppliers',
            value: stats.totalSuppliers.toString(),
            icon: LucideIcons.truck400,
            color: AppColors.orange700,
            change: 'Active suppliers',
            trend: TrendType.neutral,
          ),
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            int columns = (constraints.maxWidth / 300).floor();

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 140,
              ),
              itemCount: statsCard.length,
              itemBuilder: (context, index) {
                final statCart = statsCard[index];
                return statCart;
              },
            );
          },
        );
      },
    );
  }

  DashboardStatsData _calculateStats(AppProvider appProvider) {
    final products = fakeProducts;
    final transactions = fakeTransactions;
    final suppliers = fakeSuppliers;

    final totalProducts = products.length;
    final lowStockItems = products
        .where((p) => p.quantity <= p.reorderThreshold)
        .length;

    final today = DateTime.now();
    final thirtyDaysFromNow = today.add(const Duration(days: 30));
    final expiringItems = products
        .where((p) => p.expiryDate.isBefore(thirtyDaysFromNow))
        .length;

    final todayTransactions = transactions
        .where(
          (t) =>
              t.date.year == today.year &&
              t.date.month == today.month &&
              t.date.day == today.day,
        )
        .toList();

    final todaySales = todayTransactions
        .where((t) => t.type == TransactionType.sale)
        .fold(0.0, (sum, t) => sum + t.price);

    return DashboardStatsData(
      totalProducts: totalProducts,
      lowStockItems: lowStockItems,
      expiringItems: expiringItems,
      todaySales: todaySales,
      todayTransactions: todayTransactions.length,
      totalSuppliers: suppliers.length,
    );
  }
}

class DashboardStatsData {
  const DashboardStatsData({
    required this.totalProducts,
    required this.lowStockItems,
    required this.expiringItems,
    required this.todaySales,
    required this.todayTransactions,
    required this.totalSuppliers,
  });

  final int totalProducts;
  final int lowStockItems;
  final int expiringItems;
  final double todaySales;
  final int todayTransactions;
  final int totalSuppliers;
}
