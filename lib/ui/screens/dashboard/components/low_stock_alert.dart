import 'package:flutter/material.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../utils/fake.dart';
import 'alert_card.dart';
import 'empty_state.dart';
import 'product_item_card.dart';

/// Widget that displays products with low stock levels.
class LowStockAlert extends StatelessWidget {
  const LowStockAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final lowStockProducts = fakeProducts
            .where((product) => product.quantity <= product.reorderThreshold)
            .toList();

        return AlertCard(
          title: 'Low Stock Alert',
          icon: LucideIcons.triangleAlert400,
          iconColor: AppColors.red,
          child: lowStockProducts.isEmpty
              ? const EmptyState(
                  icon: LucideIcons.package,
                  message: 'All products are well stocked',
                )
              : Column(
                  children: lowStockProducts.map((product) {
                    final criticalityColor = _getCriticalityColor(
                      product.quantity,
                      product.reorderThreshold,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProductItemCard(
                        productName: product.name,
                        subtitle:
                            'Reorder threshold: ${product.reorderThreshold}',
                        badgeText: '${product.quantity} left',
                        badgeColor: criticalityColor,
                        additionalInfo:
                            '\$${product.price.toStringAsFixed(2)}/unit',
                      ),
                    );
                  }).toList(),
                ),
        );
      },
    );
  }

  Color _getCriticalityColor(int quantity, int threshold) {
    final ratio = quantity / threshold;
    if (ratio <= 0.5) return AppColors.red;
    if (ratio <= 0.8) return AppColors.orange500;
    return AppColors.warningColor;
  }
}
