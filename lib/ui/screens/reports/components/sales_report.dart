import 'package:flutter/material.dart';
import 'package:pharmacie_stock/config/internationalizations/internationalization.dart';
import 'package:pharmacie_stock/models/transaction.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/utils/formatters.dart';
import 'package:pharmacie_stock/utils/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../reports_provider.dart';
import 'metric_cart.dart';

class SalesReport extends StatelessWidget {
  const SalesReport({
    super.key,
    required this.reportData,
    required this.appProvider,
  });

  final Map<String, dynamic> reportData;
  final AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    final salesTransactions = reportData['sales'] as List<Transaction>;
    final totalSales = reportData['totalSales'] as double;
    final totalItems = reportData['totalItems'] as int;
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SalesMetricsGrid(
          totalSales: totalSales,
          totalItems: totalItems,
          salesTransactions: salesTransactions,
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            return Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Expanded(
                  flex: isDesktop ? 1 : 0,
                  child: SizedBox(
                    width: double.infinity,
                    child: _TopSellingProductsCard(
                      salesTransactions: salesTransactions,
                      appProvider: appProvider,
                    ),
                  ),
                ),
                Expanded(
                  flex: isDesktop ? 1 : 0,
                  child: SizedBox(
                    width: double.infinity,

                    child: _RecentSalesTransactionsCard(
                      salesTransactions: salesTransactions,
                      appProvider: appProvider,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SalesMetricsGrid extends StatelessWidget {
  const _SalesMetricsGrid({
    required this.totalSales,
    required this.totalItems,
    required this.salesTransactions,
  });

  final double totalSales;
  final int totalItems;
  final List<Transaction> salesTransactions;

  @override
  Widget build(BuildContext context) {
    final reportsProvider = context.watch<ReportsProvider>();
    final intl = context.read<Internationalization>();

    final metricsCard = [
      MetricCard(
        title: 'Total Sales',
        value: Formatters.formatCurrency(totalSales, intl.locale),
        subtitle: reportsProvider.dateRangeText,
        icon: LucideIcons.wallet400,
        color: Colors.green,
      ),
      MetricCard(
        title: 'Items Sold',
        value: totalItems.toString(),
        subtitle: 'Units sold',
        icon: LucideIcons.package400,
        color: Colors.blue,
      ),
      MetricCard(
        title: 'Transactions',
        value: salesTransactions.length.toString(),
        subtitle: 'Sales completed',
        icon: LucideIcons.fileText400,
        color: Colors.purple,
      ),
      MetricCard(
        title: 'Avg. Sale',
        value: salesTransactions.isNotEmpty
            ? Formatters.formatCurrency(
                (totalSales / salesTransactions.length),
                intl.locale,
              )
            : Formatters.formatCurrency(0, intl.locale),
        subtitle: 'Per transaction',
        icon: LucideIcons.trendingUp400,
        color: Colors.orange,
      ),
    ];
    return Consumer<ReportsProvider>(
      builder: (context, reports, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            int columns = (constraints.maxWidth / 250).floor();

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 150,
              ),
              itemCount: metricsCard.length,
              itemBuilder: (context, index) {
                final statCart = metricsCard[index];
                return statCart;
              },
            );
          },
        );
      },
    );
  }
}

class _TopSellingProductsCard extends StatelessWidget {
  const _TopSellingProductsCard({
    required this.salesTransactions,
    required this.appProvider,
  });

  final List<Transaction> salesTransactions;
  final AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    final topProducts = _getTopProducts();

    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Selling Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Best performers by revenue',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...topProducts.take(5).map((entry) {
              final index = topProducts.indexOf(entry);
              final data = entry.value;
              return _TopProductItem(
                index: index,
                productName: data['name'] as String,
                quantity: data['quantity'] as int,
                revenue: data['revenue'] as double,
              );
            }),
          ],
        ),
      ),
    );
  }

  List<MapEntry<String, Map<String, dynamic>>> _getTopProducts() {
    final productSales = <String, Map<String, dynamic>>{};

    for (final transaction in salesTransactions) {
      final product = appProvider.products.firstWhere(
        (p) => p.id == transaction.productId,
      );

      if (productSales.containsKey(product.id)) {
        productSales[product.id]!['quantity'] += transaction.quantity;
        productSales[product.id]!['revenue'] += transaction.total;
      } else {
        productSales[product.id] = {
          'name': product.name,
          'quantity': transaction.quantity,
          'revenue': transaction.total,
        };
      }
    }

    final topProducts = productSales.entries.toList()
      ..sort(
        (a, b) => (b.value['revenue'] as double).compareTo(
          a.value['revenue'] as double,
        ),
      );

    return topProducts;
  }
}

class _TopProductItem extends StatelessWidget {
  const _TopProductItem({
    required this.index,
    required this.productName,
    required this.quantity,
    required this.revenue,
  });

  final int index;
  final String productName;
  final int quantity;
  final double revenue;

  @override
  Widget build(BuildContext context) {
    final intl = context.watch<Internationalization>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$quantity units sold',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            Formatters.formatCurrency(revenue, intl.locale),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _RecentSalesTransactionsCard extends StatelessWidget {
  const _RecentSalesTransactionsCard({
    required this.salesTransactions,
    required this.appProvider,
  });

  final List<Transaction> salesTransactions;
  final AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Recent sales activity',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...salesTransactions.take(5).map((transaction) {
              final product = appProvider.products.firstWhere(
                (p) => p.id == transaction.productId,
              );
              return _SalesTransactionItem(
                transaction: transaction,
                product: product,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SalesTransactionItem extends StatelessWidget {
  const _SalesTransactionItem({
    required this.transaction,
    required this.product,
  });

  final Transaction transaction;
  final dynamic product; // Replace with your Product model type

  @override
  Widget build(BuildContext context) {
    final intl = context.watch<Internationalization>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  Formatters.formatDateTimeShort(transaction.date, intl.locale),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${transaction.quantity} units'),
              Text(
                Formatters.formatCurrency(
                  transaction.total.toDouble(),
                  intl.locale,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
