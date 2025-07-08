import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';

class SalesHeader extends StatelessWidget {
  final int cartItemCount;
  final VoidCallback onBackPressed;

  const SalesHeader({
    super.key,
    required this.cartItemCount,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: AppConstants.maxWidth),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.headerPadding,
          vertical: AppConstants.spacingXL,
        ),
        child: Row(
          children: [
            ShadButton.ghost(
              onPressed: onBackPressed,
              backgroundColor: Colors.grey[100],
              child: const Icon(Icons.arrow_back, size: 24),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nouvelle Vente',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Enregistrer une transaction',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ],
              ),
            ),
            if (cartItemCount > 0) _buildCartIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildCartIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shopping_cart, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Text(
            '$cartItemCount article(s)',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
