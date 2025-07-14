import 'package:flutter/material.dart';
import 'package:pharmacie_stock/utils/app_colors.dart';
import 'package:pharmacie_stock/utils/app_constants.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// A reusable product item card widget for displaying product information.
class ProductItemCard extends StatelessWidget {
  const ProductItemCard({
    super.key,
    required this.productName,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.additionalInfo,
  });

  final String productName;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final String additionalInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.contentPadding),
      decoration: BoxDecoration(
        color: AppColors.cobalt.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(productName, style: ShadTheme.of(context).textTheme.large),
                const SizedBox(height: 2),
                Text(subtitle, style: ShadTheme.of(context).textTheme.muted),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeText,
                  style: ShadTheme.of(context).textTheme.large,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                additionalInfo,
                style: ShadTheme.of(context).textTheme.muted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
