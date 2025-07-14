import 'package:flutter/material.dart';
import 'package:pharmacie_stock/utils/app_colors.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NotificationBadge extends StatelessWidget {
  final int count;
  final Widget child;
  final Color? backgroundColor;
  final Color? textColor;

  const NotificationBadge({
    super.key,
    required this.count,
    required this.child,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (count > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color:
                    backgroundColor ??
                    ShadTheme.of(context).colorScheme.destructive,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: textColor ?? AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
