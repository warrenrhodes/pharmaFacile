import 'package:flutter/material.dart';
import 'package:pharmacie_stock/config/internationalizations/internationalization.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/utils/formatters.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'metric_cart.dart';

class SupplierReport extends StatelessWidget {
  const SupplierReport({super.key, required this.appProvider});

  final AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SupplierMetricsGrid(appProvider: appProvider),
        const SizedBox(height: 24),
        _SupplierPerformanceCard(appProvider: appProvider),
      ],
    );
  }
}

class _SupplierMetricsGrid extends StatelessWidget {
  const _SupplierMetricsGrid({required this.appProvider});

  final AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    final intl = context.watch<Internationalization>();
    final supplierBreakdown = _getSupplierBreakdown();
    final totalValue = supplierBreakdown.values.fold(
      0.0,
      (sum, data) => sum + (data['value'] as double),
    );

    final metricsCard = [
      MetricCard(
        title: 'Total Suppliers',
        value: appProvider.suppliers.length.toString(),
        subtitle: 'Active suppliers',
        icon: LucideIcons.building,
        color: Colors.blue,
      ),
      MetricCard(
        title: 'Avg Products',
        value: appProvider.suppliers.isNotEmpty
            ? (appProvider.products.length / appProvider.suppliers.length)
                  .round()
                  .toString()
            : '0',
        subtitle: 'Per supplier',
        icon: LucideIcons.trendingUp,
        color: Colors.green,
      ),
      MetricCard(
        title: 'Total Value',
        value: Formatters.formatCurrency(totalValue, intl.locale),
        subtitle: 'All suppliers',
        icon: LucideIcons.wallet,
        color: Colors.purple,
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

  Map<String, Map<String, dynamic>> _getSupplierBreakdown() {
    final supplierBreakdown = <String, Map<String, dynamic>>{};

    for (final product in appProvider.products) {
      final supplier = appProvider.suppliers.firstWhere(
        (s) => s.id == product.supplierId,
      );

      if (supplierBreakdown.containsKey(supplier.id)) {
        supplierBreakdown[supplier.id]!['products']++;
        supplierBreakdown[supplier.id]!['value'] +=
            product.price * product.quantity;
      } else {
        supplierBreakdown[supplier.id] = {
          'name': supplier.name,
          'products': 1,
          'value': product.price * product.quantity,
        };
      }
    }

    return supplierBreakdown;
  }
}

class _SupplierPerformanceCard extends StatelessWidget {
  const _SupplierPerformanceCard({required this.appProvider});

  final AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    final intl = Provider.of<Internationalization>(context);
    final supplierBreakdown = _getSupplierBreakdown();
    final totalValue = supplierBreakdown.values.fold(
      0.0,
      (sum, data) => sum + (data['value'] as double),
    );

    return ShadCard(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Supplier Performance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Products and value by supplier',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Supplier')),
                  DataColumn(label: Text('Products')),
                  DataColumn(label: Text('Total Value')),
                  DataColumn(label: Text('Market Share')),
                ],
                rows: supplierBreakdown.entries.map((entry) {
                  final data = entry.value;
                  final marketShare = totalValue > 0
                      ? (data['value'] / totalValue * 100)
                      : 0.0;

                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          data['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      DataCell(Text((data['products'] as int).toString())),
                      DataCell(
                        Text(
                          Formatters.formatCurrency(
                            data['value'] as double,
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
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${marketShare.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
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

  Map<String, Map<String, dynamic>> _getSupplierBreakdown() {
    final supplierBreakdown = <String, Map<String, dynamic>>{};

    for (final product in appProvider.products) {
      final supplier = appProvider.suppliers.firstWhere(
        (s) => s.id == product.supplierId,
      );

      if (supplierBreakdown.containsKey(supplier.id)) {
        supplierBreakdown[supplier.id]!['products']++;
        supplierBreakdown[supplier.id]!['value'] +=
            product.price * product.quantity;
      } else {
        supplierBreakdown[supplier.id] = {
          'name': supplier.name,
          'products': 1,
          'value': product.price * product.quantity,
        };
      }
    }

    return supplierBreakdown;
  }
}
