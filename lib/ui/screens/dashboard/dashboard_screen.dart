import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:pharmacie_stock/config/internationalizations/internationalization.dart';
import 'package:pharmacie_stock/utils/app_constants.dart';
import 'package:pharmacie_stock/utils/formatters.dart';
import 'package:pharmacie_stock/utils/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'components/dashboard_stats.dart';
import 'components/expiry_alert.dart';
import 'components/low_stock_alert.dart';
import 'components/recent_activity.dart';

/// Main dashboard widget that combines all dashboard components.
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final intl = context.watch<Internationalization>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dashboard', style: theme.textTheme.h4),
              Text(
                'Last updated: ${Formatters.formatDate(clock.now(), intl.locale)} ${Formatters.formatTime(clock.now(), intl.locale)}',
                style: theme.textTheme.muted,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.largePadding),
          const DashboardStats(),
          const SizedBox(height: AppConstants.largePadding),
          LayoutBuilder(
            builder: (context, constraints) {
              if (!ResponsiveUtils.isTablet(context) &&
                  constraints.maxWidth > 800) {
                return _buildWideLayout();
              } else {
                return _buildNarrowLayout();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: RecentActivity()),
        SizedBox(width: AppConstants.largePadding),

        Expanded(
          child: Column(
            children: [
              LowStockAlert(),
              SizedBox(height: AppConstants.largePadding),
              ExpiryAlert(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return const Column(
      children: [
        RecentActivity(),
        SizedBox(height: AppConstants.largePadding),
        LowStockAlert(),
        SizedBox(height: AppConstants.largePadding),
        ExpiryAlert(),
      ],
    );
  }
}
