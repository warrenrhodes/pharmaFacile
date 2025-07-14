// ReportsProvider - State Management
import 'package:flutter/material.dart';
import 'package:pharmacie_stock/models/transaction.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';

class ReportsProvider extends ChangeNotifier {
  String _reportType = 'sales';
  String _dateRange = 'today';

  String get reportType => _reportType;
  String get dateRange => _dateRange;

  String get dateRangeText {
    switch (_dateRange) {
      case 'today':
        return 'Today';
      case 'week':
        return 'Last 7 days';
      case 'month':
        return 'This month';
      default:
        return 'Today';
    }
  }

  void setReportType(String type) {
    if (_reportType != type) {
      _reportType = type;
      notifyListeners();
    }
  }

  void setDateRange(String range) {
    if (_dateRange != range) {
      _dateRange = range;
      notifyListeners();
    }
  }

  Map<String, dynamic> getReportData(AppProvider appProvider) {
    final now = DateTime.now();
    final startDate = _getStartDate(now);

    final filteredTransactions = appProvider.transactions
        .where(
          (t) =>
              t.date.isAfter(startDate) &&
              t.date.isBefore(now.add(const Duration(days: 1))),
        )
        .toList();

    final salesTransactions = filteredTransactions
        .where((t) => t.type == TransactionType.sale)
        .toList();

    return {
      'transactions': filteredTransactions,
      'sales': salesTransactions,
      'totalSales': salesTransactions.fold(0.0, (sum, t) => sum + t.total),
      'totalItems': salesTransactions.fold(0, (sum, t) => sum + t.quantity),
    };
  }

  DateTime _getStartDate(DateTime now) {
    switch (_dateRange) {
      case 'today':
        return DateTime(now.year, now.month, now.day);
      case 'week':
        return now.subtract(const Duration(days: 7));
      case 'month':
        return DateTime(now.year, now.month, 1);
      default:
        return DateTime(now.year, now.month, now.day);
    }
  }
}
