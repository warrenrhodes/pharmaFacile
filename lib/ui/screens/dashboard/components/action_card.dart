import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../utils/app_constants.dart';
import '../utils.dart';

class ActionCard extends StatelessWidget {
  final NavigationItem item;
  final VoidCallback onTap;

  const ActionCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      child: ShadCard(
        padding: EdgeInsets.zero,
        radius: BorderRadius.circular(AppConstants.cardRadius),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.cardRadius),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: item.gradientColors,
            ),
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: AppConstants.cardIconSize,
                height: AppConstants.cardIconSize,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  item.icon,
                  color: Colors.white,
                  size: AppConstants.spacingLarge,
                ),
              ),
              const SizedBox(height: AppConstants.spacingXL),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppConstants.spacingM),
              Text(
                item.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.92),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
