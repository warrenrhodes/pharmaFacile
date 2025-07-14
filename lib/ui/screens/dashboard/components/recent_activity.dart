import 'package:flutter/material.dart';
import 'package:pharmacie_stock/models/product.dart';
import 'package:pharmacie_stock/models/transaction.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/utils/app_colors.dart';
import 'package:pharmacie_stock/utils/app_constants.dart';
import 'package:pharmacie_stock/utils/fake.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'alert_card.dart';

/// Widget that displays recent transaction activities.
class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final recentTransactions = fakeTransactions.toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        final limitedTransactions = recentTransactions.take(10).toList();

        return AlertCard(
          title: 'Recent Activity',
          icon: LucideIcons.activity400,
          iconColor: AppColors.cobalt,
          child: limitedTransactions.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No recent activity',
                      style: ShadTheme.of(context).textTheme.muted,
                    ),
                  ),
                )
              : Column(
                  children: limitedTransactions.map((transaction) {
                    final productName = _getProductName(
                      appProvider,
                      transaction.productId,
                    );
                    final userName = _getUserName(
                      appProvider,
                      transaction.userId,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _TransactionItem(
                        transaction: transaction,
                        productName: productName,
                        userName: userName,
                      ),
                    );
                  }).toList(),
                ),
        );
      },
    );
  }

  String _getProductName(AppProvider appProvider, String productId) {
    final product = fakeProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => Product(
        id: '',
        name: 'Unknown Product',
        quantity: 0,
        price: 0,
        reorderThreshold: 0,
        expiryDate: DateTime.now(),
        supplierId: '',
        barcode: '',
        categoryId: '',
        createdAtInUtc: DateTime.now(),
        updatedAtInUtc: DateTime.now(),
      ),
    );
    return product.name;
  }

  String _getUserName(AppProvider appProvider, String userId) {
    final user = fakeUsers.firstWhere((u) => u.id == userId);
    return user.name;
  }
}

/// Individual transaction item widget.
class _TransactionItem extends StatelessWidget {
  const _TransactionItem({
    required this.transaction,
    required this.productName,
    required this.userName,
  });

  final Transaction transaction;
  final String productName;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final isOut = transaction.type == TransactionType.sale;

    return Container(
      padding: const EdgeInsets.all(AppConstants.contentPadding),
      decoration: BoxDecoration(
        color: AppColors.cobalt.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isOut
                  ? AppColors.red.withValues(alpha: 0.1)
                  : AppColors.lightGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isOut ? LucideIcons.arrowDownLeft400 : LucideIcons.arrowUpLeft400,
              size: 16,
              color: isOut ? AppColors.red : AppColors.lightGreen,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        productName,
                        style: ShadTheme.of(context).textTheme.large,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${isOut ? '-' : '+'}${transaction.quantity}',
                      style: ShadTheme.of(context).textTheme.large.copyWith(
                        color: isOut ? AppColors.red : AppColors.lightGreen,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'by $userName',
                        style: ShadTheme.of(context).textTheme.muted,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _formatDateTime(transaction.date),
                      style: ShadTheme.of(context).textTheme.muted,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                if (transaction.receiptNumber != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Receipt: ${transaction.receiptNumber}',
                    style: ShadTheme.of(
                      context,
                    ).textTheme.muted.copyWith(color: AppColors.cobalt),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
