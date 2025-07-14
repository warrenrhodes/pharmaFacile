import 'package:flutter/material.dart';
import 'package:pharmacie_stock/utils/app_constants.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// A reusable alert card widget with a title, icon, and child content.
class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      title: Row(
        children: [
          Icon(icon, color: iconColor, size: AppConstants.iconSize),
          const SizedBox(width: AppConstants.smallPadding),
          Text(title, style: ShadTheme.of(context).textTheme.h4),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.contentPadding),
        child: child,
      ),
    );
  }
}
