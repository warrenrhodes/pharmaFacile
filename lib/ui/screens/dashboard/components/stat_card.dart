import 'package:flutter/material.dart';
import 'package:pharmacie_stock/utils/app_constants.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../widgets/container_gradiant.dart';

/// Reusable statistics card widget
class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? footnote;
  final List<Color> gradientColors;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    this.footnote,
  });

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: const EdgeInsets.all(AppConstants.spacingS),
      radius: BorderRadius.circular(AppConstants.cardRadius),
      shadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Row(
          children: [
            GradientContainer(
              width: AppConstants.headerIconSize,
              height: AppConstants.headerIconSize,
              colors: gradientColors,
              borderRadius: BorderRadius.circular(AppConstants.spacingL),
              boxShadow: [
                BoxShadow(
                  color: gradientColors.first.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              child: Icon(
                icon,
                color: Colors.white,
                size: AppConstants.iconSize,
              ),
            ),
            const SizedBox(width: AppConstants.spacingXL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXS),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: gradientColors.last,
                    ),
                  ),
                  if (footnote != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      footnote!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
