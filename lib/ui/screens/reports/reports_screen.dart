import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmacie_stock/models/transaction.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/utils/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'components/inventory_report.dart';
import 'components/sales_report.dart';
import 'components/suppliers_report.dart';
import 'reports_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportsProvider(),
      child: const ReportsScreenContent(),
    );
  }
}

class ReportsScreenContent extends StatelessWidget {
  const ReportsScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, ReportsProvider>(
      builder: (context, appProvider, reports, _) {
        final reportData = reports.getReportData(appProvider);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ReportsHeader(),
              const SizedBox(height: 32),
              ReportsControlsCard(
                reportType: reports.reportType,
                dateRange: reports.dateRange,
                onExport: () => _exportReport(context, appProvider, reports),
              ),
              const SizedBox(height: 24),
              ReportsContent(
                reportType: reports.reportType,
                reportData: reportData,
                appProvider: appProvider,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _exportReport(
    BuildContext context,
    AppProvider appProvider,
    ReportsProvider reports,
  ) async {
    try {
      final csvData = <List<dynamic>>[];

      if (reports.reportType == 'sales') {
        final reportData = reports.getReportData(appProvider);
        final salesTransactions = reportData['sales'] as List<Transaction>;

        csvData.add(['Date', 'Product', 'Quantity', 'Price', 'Total', 'Notes']);
        for (final transaction in salesTransactions) {
          final product = appProvider.products.firstWhere(
            (p) => p.id == transaction.productId,
          );
          csvData.add([
            DateFormat('yyyy-MM-dd HH:mm').format(transaction.date),
            product.name,
            transaction.quantity,
            transaction.price,
            transaction.total,
            transaction.notes ?? '',
          ]);
        }
      } else if (reports.reportType == 'appProvider') {
        csvData.add([
          'Name',
          'Barcode',
          'Category',
          'Supplier',
          'Price',
          'Quantity',
          'Min Stock',
          'Expiry Date',
          'Value',
        ]);
        for (final product in appProvider.products) {
          final category = appProvider.categories.firstWhere(
            (c) => c.id == product.categoryId,
          );
          final supplier = appProvider.suppliers.firstWhere(
            (s) => s.id == product.supplierId,
          );
          csvData.add([
            product.name,
            product.barcode,
            category.name,
            supplier.name,
            product.price,
            product.quantity,
            product.reorderThreshold,
            DateFormat('yyyy-MM-dd').format(product.expiryDate),
            product.price * product.quantity,
          ]);
        }
      }

      final csv = const ListToCsvConverter().convert(csvData);
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          '${reports.reportType}_report_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(csv);

      if (context.mounted) {
        ShadToaster.of(context).show(
          ShadToast(
            title: const Text('Export Successful'),
            description: Text('Report saved to ${file.path}'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Export Failed'),
            description: Text('Error: $e'),
          ),
        );
      }
    }
  }
}

class ReportsHeader extends StatelessWidget {
  const ReportsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reports & Analytics', style: theme.textTheme.h4),
        const SizedBox(height: 4),
        Text(
          'Generate and export business reports',
          style: theme.textTheme.muted,
        ),
      ],
    );
  }
}

class ReportsControlsCard extends StatelessWidget {
  const ReportsControlsCard({
    super.key,
    required this.reportType,
    required this.dateRange,
    required this.onExport,
  });

  final String reportType;
  final String dateRange;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final isDevice = ResponsiveUtils.isMobile(context);
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Report Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Configure your report parameters',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return Flex(
                  direction: isDevice ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 12,
                  children: [
                    ReportTypeSelector(reportType: reportType),
                    DateRangeSelector(dateRange: dateRange),
                    ExportButton(onExport: onExport),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ReportTypeSelector extends StatelessWidget {
  const ReportTypeSelector({super.key, required this.reportType});

  final String reportType;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsProvider>(
      builder: (context, reports, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Report Type',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ShadSelect<String>(
              maxWidth: 350,
              minWidth: 250,
              placeholder: const Text('Select report type'),
              options: const [
                ShadOption(value: 'sales', child: Text('Sales Report')),
                ShadOption(value: 'inventory', child: Text('Inventory Report')),
                ShadOption(value: 'supplier', child: Text('Supplier Report')),
              ],
              selectedOptionBuilder: (context, value) =>
                  Text(_getReportTypeLabel(value)),
              onChanged: (value) => reports.setReportType(value ?? 'sales'),
            ),
          ],
        );
      },
    );
  }

  String _getReportTypeLabel(String? value) {
    switch (value) {
      case 'sales':
        return 'Sales Report';
      case 'inventory':
        return 'Inventory Report';
      case 'supplier':
        return 'Supplier Report';
      default:
        return 'Sales Report';
    }
  }
}

class DateRangeSelector extends StatelessWidget {
  const DateRangeSelector({super.key, required this.dateRange});

  final String dateRange;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsProvider>(
      builder: (context, reports, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date Range',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ShadSelect<String>(
              maxWidth: 350,
              minWidth: 250,
              placeholder: const Text('Select date range'),
              options: const [
                ShadOption(value: 'today', child: Text('Today')),
                ShadOption(value: 'week', child: Text('Last 7 Days')),
                ShadOption(value: 'month', child: Text('This Month')),
              ],
              selectedOptionBuilder: (context, value) =>
                  Text(_getDateRangeLabel(value)),
              onChanged: (value) => reports.setDateRange(value ?? 'today'),
            ),
          ],
        );
      },
    );
  }

  String _getDateRangeLabel(String? value) {
    switch (value) {
      case 'today':
        return 'Today';
      case 'week':
        return 'Last 7 Days';
      case 'month':
        return 'This Month';
      default:
        return 'Today';
    }
  }
}

class ExportButton extends StatelessWidget {
  const ExportButton({super.key, required this.onExport});

  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      onPressed: onExport,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.download, size: 16),
          SizedBox(width: 8),
          Text('Export CSV'),
        ],
      ),
    );
  }
}

class ReportsContent extends StatelessWidget {
  const ReportsContent({
    super.key,
    required this.reportType,
    required this.reportData,
    required this.appProvider,
  });

  final String reportType;
  final Map<String, dynamic> reportData;
  final AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    switch (reportType) {
      case 'sales':
        return SalesReport(reportData: reportData, appProvider: appProvider);
      case 'inventory':
        return InventoryReport(appProvider: appProvider);
      case 'supplier':
        return SupplierReport(appProvider: appProvider);
      default:
        return SalesReport(reportData: reportData, appProvider: appProvider);
    }
  }
}
