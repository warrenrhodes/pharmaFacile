import 'package:flutter/material.dart';
import 'package:pharmacie_stock/config/internationalizations/internationalization.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/utils/formatters.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'metric_cart.dart';

class InventoryReport extends StatelessWidget {
  const InventoryReport({super.key, required this.appProvider});

  final AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InventoryMetricsGrid(appProvider: appProvider),
        const SizedBox(height: 24),
        InventoryCategoryBreakdownCard(appProvider: appProvider),
      ],
    );
  }
}

class InventoryMetricsGrid extends StatelessWidget {
  const InventoryMetricsGrid({super.key, required this.appProvider});

  final AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    final intl = context.read<Internationalization>();
    final metricsCard = [
      MetricCard(
        title: 'Total Products',
        value: appProvider.products.length.toString(),
        subtitle: 'Active products',
        icon: LucideIcons.package400,
        color: Colors.blue,
      ),
      MetricCard(
        title: 'Inventory Value',
        value: Formatters.formatCurrency(
          appProvider.totalInventoryValue,
          intl.locale,
        ),
        subtitle: 'Total stock value',
        icon: LucideIcons.wallet400,
        color: Colors.green,
      ),
      MetricCard(
        title: 'Low Stock',
        value: appProvider.lowStockProducts.length.toString(),
        subtitle: 'Need reordering',
        icon: LucideIcons.triangleAlert400,
        color: Colors.orange,
      ),
      MetricCard(
        title: 'Expiring Soon',
        value: appProvider.expiringProducts.length.toString(),
        subtitle: 'Within 30 days',
        icon: LucideIcons.calendar400,
        color: Colors.red,
      ),
    ];

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
  }
}

class InventoryCategoryBreakdownCard extends StatelessWidget {
  const InventoryCategoryBreakdownCard({super.key, required this.appProvider});

  final AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    final categoryBreakdown = _getCategoryBreakdown();
    final intl = context.watch<Internationalization>();

    return ShadCard(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inventory by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Stock distribution across categories',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Products')),
                  DataColumn(label: Text('Total Value')),
                  DataColumn(label: Text('Percentage')),
                ],
                rows: categoryBreakdown.entries.map((entry) {
                  final data = entry.value;
                  final percentage = appProvider.totalInventoryValue > 0
                      ? (data['value'] / appProvider.totalInventoryValue * 100)
                      : 0.0;

                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          data['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      DataCell(Text((data['count'] as int).toString())),
                      DataCell(
                        Text(
                          Formatters.formatCurrency(
                            (data['value'] as double),
                            intl.locale,
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Map<String, dynamic>> _getCategoryBreakdown() {
    final categoryBreakdown = <String, Map<String, dynamic>>{};

    for (final product in appProvider.products) {
      final category = appProvider.categories.firstWhere(
        (c) => c.id == product.categoryId,
      );

      if (categoryBreakdown.containsKey(category.id)) {
        categoryBreakdown[category.id]!['count']++;
        categoryBreakdown[category.id]!['value'] +=
            product.price * product.quantity;
      } else {
        categoryBreakdown[category.id] = {
          'name': category.name,
          'count': 1,
          'value': product.price * product.quantity,
        };
      }
    }

    return categoryBreakdown;
  }
}
