import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../utils.dart';

class LowStockAlert extends StatelessWidget {
  final List<LowStockProduct> lowStockProducts;

  const LowStockAlert({super.key, required this.lowStockProducts});

  @override
  Widget build(BuildContext context) {
    if (lowStockProducts.isEmpty) return const SizedBox.shrink();

    String formatLowStockProducts(
      List<LowStockProduct> products, {
      int maxItems = 3,
    }) {
      final displayProducts = products
          .take(maxItems)
          .map((p) => p.toString())
          .join(', ');
      return displayProducts + (products.length > maxItems ? '...' : '');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingXXL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: AppColors.warningGradient,
        ),
        borderRadius: BorderRadius.circular(20),
        border: const Border(
          left: BorderSide(color: AppColors.warningBorder, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXL),
        child: Row(
          children: [
            Container(
              width: AppConstants.smallIconSize,
              height: AppConstants.smallIconSize,
              decoration: BoxDecoration(
                color: AppColors.warningIconBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warningIcon,
                size: 28,
              ),
            ),
            const SizedBox(width: AppConstants.spacingL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppConstants.lowStockAlertTitle,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warningText,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXS),
                  Text(
                    '${lowStockProducts.length}${AppConstants.productsRequireRestock}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.warningTextAlt,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXS),
                  Text(
                    formatLowStockProducts(lowStockProducts),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.warningIcon,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
