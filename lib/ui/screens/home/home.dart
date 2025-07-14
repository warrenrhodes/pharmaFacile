import 'package:flutter/material.dart';
import 'package:pharmacie_stock/ui/screens/home/home_comtroller.dart';
import 'package:pharmacie_stock/ui/screens/inventory/inventory_view.dart';
import 'package:pharmacie_stock/ui/screens/reports/reports_screen.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/responsive_utils.dart';
import '../../widgets/app_header/app_header.dart';
import '../../widgets/sidebar/sidebar.dart';
import '../dashboard/dashboard_screen.dart';
import '../sales/sales_screen.dart';
import '../settings/settings_screen.dart';
import '../suppliers/suppliers_screen.dart';
import '../users/users_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabletBreakpoint = ResponsiveUtils.isTablet(context);

    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      builder: (context, asyncSnapshot) {
        return Scaffold(
          backgroundColor: ShadTheme.of(context).colorScheme.secondary,
          body: Consumer<HomeProvider>(
            builder: (context, homeProvider, child) {
              return Stack(
                children: [
                  Row(
                    children: [
                      if (!tabletBreakpoint)
                        SidebarWidget(
                          activeTab: homeProvider.activeTab,
                          onTabChange: homeProvider.changeTab,
                          isOpen: true,
                        ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: tabletBreakpoint ? 0 : 20,
                          ),
                          decoration: BoxDecoration(
                            color: ShadTheme.of(context).colorScheme.background,
                            borderRadius: tabletBreakpoint
                                ? null
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(
                                      AppConstants.cardRadius,
                                    ),
                                    bottomLeft: Radius.circular(
                                      AppConstants.cardRadius,
                                    ),
                                  ),
                          ),
                          child: Column(
                            children: [
                              HeaderWidget(
                                onMenuClick: homeProvider.toggleSidebar,
                                isSidebarOpen: homeProvider.isSidebarOpen,
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(
                                    tabletBreakpoint ? 16.0 : 24.0,
                                  ),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 1280,
                                    ),
                                    child: GestureDetector(
                                      onTap: !tabletBreakpoint
                                          ? null
                                          : () => homeProvider.toggleSidebar(
                                              value: false,
                                            ),
                                      child: switch (homeProvider.activeTab) {
                                        DashboardItem.dashboard =>
                                          const Dashboard(),
                                        DashboardItem.inventory =>
                                          const InventoryView(),
                                        DashboardItem.sales =>
                                          const SalesScreen(),
                                        DashboardItem.reports =>
                                          const ReportsScreen(),
                                        DashboardItem.users =>
                                          const UsersScreen(),
                                        DashboardItem.suppliers =>
                                          const SuppliersScreen(),
                                        DashboardItem.settings =>
                                          const SettingsScreen(),
                                        _ => const SizedBox(),
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Mobile sidebar
                  if (tabletBreakpoint)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      left: homeProvider.isSidebarOpen ? 0 : -280,
                      top: 0,
                      bottom: 0,
                      child: SidebarWidget(
                        activeTab: homeProvider.activeTab,
                        onTabChange: homeProvider.changeTab,
                        isOpen: homeProvider.isSidebarOpen,
                      ),
                    ),

                  if (homeProvider.isSidebarOpen && tabletBreakpoint)
                    GestureDetector(
                      onTap: homeProvider.toggleSidebar,
                      child: const SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
