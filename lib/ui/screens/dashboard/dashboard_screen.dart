import 'package:flutter/material.dart';
import 'package:pharmacie_stock/ui/screens/report_screen.dart';
import 'package:pharmacie_stock/ui/screens/setting.dart';
import 'package:pharmacie_stock/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/formatters.dart';
import '../sales/sales_screen.dart';
import '../stock_screen.dart';
import 'components/action_card.dart';
import 'components/app_header.dart';
import 'components/low_stock_alert.dart';
import 'components/stat_card.dart';
import 'dashboard_controller.dart';
import 'utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardController(),
      builder: (context, value) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.backgroundGradient,
              ),
            ),
            child: Column(
              children: [
                const AppHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.contentPadding,
                      vertical: AppConstants.spacingXXL,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppConstants.maxWidth,
                      ),
                      child: Consumer<DashboardController>(
                        builder: (context, dashboardProvider, child) {
                          final stats = dashboardProvider.stats;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LowStockAlert(
                                lowStockProducts: stats.lowStockProducts,
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final isWide =
                                      constraints.maxWidth >
                                      AppConstants.tabletBreakpoint;
                                  return Flex(
                                    direction: isWide
                                        ? Axis.horizontal
                                        : Axis.vertical,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (isWide) ...[
                                        Expanded(
                                          child: StatCard(
                                            icon: Icons.trending_up,
                                            title: Formatters.formatCurrency(
                                              stats.todaysRevenue,
                                            ),
                                            subtitle:
                                                AppConstants.todaysSalesLabel,
                                            footnote:
                                                '${stats.todaysSalesCount}${AppConstants.transactionsSuffix}',
                                            gradientColors:
                                                AppColors.greenGradient,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: AppConstants.cardRadius,
                                        ),
                                        Expanded(
                                          child: StatCard(
                                            icon: Icons.inventory_2,
                                            title: '${stats.lowStockCount}',
                                            subtitle:
                                                AppConstants.lowStockLabel,
                                            footnote:
                                                '${AppConstants.totalProductsPrefix}${stats.totalProducts}${AppConstants.totalProductsSuffix}',
                                            gradientColors:
                                                AppColors.orangeGradient,
                                          ),
                                        ),
                                      ] else ...[
                                        StatCard(
                                          icon: Icons.trending_up,
                                          title: Formatters.formatCurrency(
                                            stats.todaysRevenue,
                                          ),
                                          subtitle:
                                              AppConstants.todaysSalesLabel,
                                          footnote:
                                              '${stats.todaysSalesCount}${AppConstants.transactionsSuffix}',
                                          gradientColors:
                                              AppColors.greenGradient,
                                        ),
                                        const SizedBox(
                                          height: AppConstants.cardRadius,
                                        ),
                                        StatCard(
                                          icon: Icons.inventory_2,
                                          title: '${stats.lowStockCount}',
                                          subtitle: AppConstants.lowStockLabel,
                                          footnote:
                                              '${AppConstants.totalProductsPrefix}${stats.totalProducts}${AppConstants.totalProductsSuffix}',
                                          gradientColors:
                                              AppColors.orangeGradient,
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),

                              const SizedBox(height: AppConstants.spacingLarge),

                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final isWide =
                                      constraints.maxWidth >
                                      AppConstants.tabletBreakpoint;
                                  return GridView.count(
                                    crossAxisCount: isWide ? 2 : 1,
                                    shrinkWrap: true,
                                    mainAxisSpacing: AppConstants.spacingXXL,
                                    crossAxisSpacing: AppConstants.spacingXXL,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    childAspectRatio: 2.2,
                                    children: homeNavigationItems.map((item) {
                                      return ActionCard(
                                        item: item,
                                        onTap: () => _navigateToScreen(
                                          context,
                                          item.routeName,
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Navigate to specified screen
  void _navigateToScreen(BuildContext context, String routeName) {
    Widget screen;

    switch (routeName) {
      case '/sales':
        screen = const SalesScreen();
        break;
      case '/stock':
        screen = const StockScreen();
        break;
      case '/reports':
        screen = const ReportScreen();
        break;
      case '/settings':
        screen = const SettingView();
        break;
      default:
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
