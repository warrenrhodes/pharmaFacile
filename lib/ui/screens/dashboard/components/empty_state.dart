import 'package:flutter/material.dart';
import 'package:pharmacie_stock/utils/app_constants.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// A reusable empty state widget for displaying when there's no data.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppConstants.largeIconSize),
            const SizedBox(height: AppConstants.smallPadding),
            Text(message, style: ShadTheme.of(context).textTheme.muted),
          ],
        ),
      ),
    );
  }
}
