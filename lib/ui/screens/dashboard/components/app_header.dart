import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/formatters.dart';
import '../../../widgets/container_gradiant.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = Formatters.formatDate(now);
    final timeStr = Formatters.formatTime(now);

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
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.headerPadding,
                vertical: AppConstants.spacingXL,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide =
                      constraints.maxWidth > AppConstants.mobileBreakpoint;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppLogo(),
                      if (isWide)
                        DateTimeSection(dateStr: dateStr, timeStr: timeStr),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GradientContainer(
          width: AppConstants.headerIconSize,
          height: AppConstants.headerIconSize,
          colors: AppColors.blueGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          child: const Icon(
            LucideIcons.package,
            color: AppColors.backgroundWhite,
            size: AppConstants.iconSize,
          ),
        ),
        const SizedBox(width: AppConstants.spacingL),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              AppConstants.appSubtitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DateTimeSection extends StatelessWidget {
  final String dateStr;
  final String timeStr;

  const DateTimeSection({
    super.key,
    required this.dateStr,
    required this.timeStr,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_today,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: AppConstants.spacingS),
            Text(
              dateStr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingXS),
        Text(
          timeStr,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlue,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          AppConstants.userLabel,
          style: TextStyle(fontSize: 14, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
