import 'package:flutter/material.dart';
import 'package:pharmacie_stock/models/product.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/utils/app_colors.dart';
import 'package:pharmacie_stock/utils/app_constants.dart';
import 'package:pharmacie_stock/utils/fake.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'alert_card.dart';
import 'empty_state.dart';
import 'product_item_card.dart';

/// Widget that displays products expiring within the next 30 days.
class ExpiryAlert extends StatelessWidget {
  const ExpiryAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final expiringProducts = _getExpiringProducts(fakeProducts);

        return AlertCard(
          title: 'Expiry Alert',
          icon: LucideIcons.calendar400,
          iconColor: AppColors.warningColor,
          child: expiringProducts.isEmpty
              ? const EmptyState(
                  icon: Icons.schedule,
                  message: 'No products expiring soon',
                )
              : Column(
                  children: expiringProducts.map((product) {
                    final daysUntilExpiry = _getDaysUntilExpiry(
                      product.expiryDate,
                    );
                    final urgencyColor = _getUrgencyColor(daysUntilExpiry);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProductItemCard(
                        productName: product.name,
                        subtitle: 'Expires: ${_formatDate(product.expiryDate)}',
                        badgeText: _formatDaysUntilExpiry(daysUntilExpiry),
                        badgeColor: urgencyColor,
                        additionalInfo: '${product.quantity} in stock',
                      ),
                    );
                  }).toList(),
                ),
        );
      },
    );
  }

  List<Product> _getExpiringProducts(List<Product> products) {
    final today = DateTime.now();
    final thirtyDaysFromNow = today.add(
      const Duration(days: AppConstants.expiryDaysThreshold),
    );

    return products
        .where((product) => product.expiryDate.isBefore(thirtyDaysFromNow))
        .toList()
      ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
  }

  int _getDaysUntilExpiry(DateTime expiryDate) {
    final today = DateTime.now();
    final difference = expiryDate.difference(today);
    return difference.inDays;
  }

  Color _getUrgencyColor(int days) {
    if (days <= 7) return AppColors.red;
    if (days <= 14) return AppColors.orange500;
    return AppColors.warningColor;
  }

  String _formatDaysUntilExpiry(int days) {
    if (days <= 0) return 'Expired';
    if (days == 1) return '1 day';
    return '$days days';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
