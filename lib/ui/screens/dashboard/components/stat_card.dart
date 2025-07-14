import 'package:flutter/material.dart';
import 'package:pharmacie_stock/utils/app_colors.dart';
import 'package:pharmacie_stock/utils/app_constants.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.change,
    this.trend,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? change;
  final TrendType? trend;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: const EdgeInsets.all(AppConstants.contentPadding),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ShadTheme.of(
                    context,
                  ).textTheme.p.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(value, style: ShadTheme.of(context).textTheme.h3),
                if (change != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    change ?? '',
                    style: ShadTheme.of(
                      context,
                    ).textTheme.muted.copyWith(color: _getTrendColor(context)),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(icon, color: color, size: AppConstants.largePadding),
          ),
        ],
      ),
    );
  }

  Color _getTrendColor(BuildContext context) {
    switch (trend) {
      case TrendType.up:
        return AppColors.lightGreen;
      case TrendType.down:
        return AppColors.red;
      case TrendType.neutral:
      default:
        return ShadTheme.of(context).colorScheme.primary;
    }
  }
}

enum TrendType { up, down, neutral }
