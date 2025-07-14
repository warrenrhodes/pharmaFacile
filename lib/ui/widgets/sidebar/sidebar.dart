import 'package:flutter/material.dart';
import 'package:pharmacie_stock/config/internationalizations/internationalization.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../models/user.dart';
import '../../../providers/app_provider.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/responsive_utils.dart';
import 'sidebar_menu_item.dart';

class SidebarWidget extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChange;
  final bool isOpen;

  const SidebarWidget({
    super.key,
    required this.activeTab,
    required this.onTabChange,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final userRole = appProvider.currentUser?.role ?? UserRole.admin;
    final isTablet = ResponsiveUtils.isTablet(context);
    final intl = context.watch<Internationalization>();
    final theme = ShadTheme.of(context);

    final List<MenuItem> menuItems = [
      MenuItem(
        id: DashboardItem.dashboard,
        label: intl.dashboard,
        icon: LucideIcons.house400,
        roles: [UserRole.admin, UserRole.pharmacist, UserRole.assistant],
      ),
      MenuItem(
        id: DashboardItem.inventory,
        label: intl.inventory,
        icon: LucideIcons.package400,
        roles: [UserRole.admin, UserRole.pharmacist, UserRole.assistant],
      ),
      MenuItem(
        id: DashboardItem.sales,
        label: intl.sales,
        icon: LucideIcons.shoppingCart400,
        roles: [UserRole.admin, UserRole.pharmacist, UserRole.assistant],
      ),
      MenuItem(
        id: DashboardItem.reports,
        label: intl.reports,
        icon: LucideIcons.chartColumn400,
        roles: [UserRole.admin, UserRole.pharmacist],
      ),
      MenuItem(
        id: DashboardItem.suppliers,
        label: intl.suppliers,
        icon: LucideIcons.truck400,
        roles: [UserRole.admin, UserRole.pharmacist],
      ),
      MenuItem(
        id: DashboardItem.users,
        label: intl.users,
        icon: LucideIcons.users400,
        roles: [UserRole.admin],
      ),
      MenuItem(
        id: DashboardItem.settings,
        label: intl.settings,
        icon: LucideIcons.settings500,
        roles: [UserRole.admin],
      ),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.translationValues(
        isTablet && !isOpen ? -AppConstants.sidebarWidth : 0,
        0,
        0,
      ),
      child: Container(
        width: AppConstants.sidebarWidth,
        height: double.infinity,

        decoration: BoxDecoration(
          color: ShadTheme.of(context).colorScheme.secondary,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primaryForeground.withValues(alpha: .1),
              blurRadius: 4,
              offset: const Offset(2, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: menuItems
                      .where((item) => _hasAccess(item.roles, userRole))
                      .map(
                        (item) => SidebarMenuItem(
                          item: item,
                          activeTab: activeTab,
                          onTabChange: onTabChange,
                          userRole: userRole,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            _buildFooter(userRole.name, context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ShadTheme.of(context).colorScheme.border,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.activity400, size: 24),
          const SizedBox(width: 12),
          Text(AppConstants.appName, style: ShadTheme.of(context).textTheme.h4),
        ],
      ),
    );
  }

  Widget _buildFooter(String userRole, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.secondary,
        border: Border(
          top: BorderSide(
            color: ShadTheme.of(context).colorScheme.border,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.user400, size: 16),
          const SizedBox(width: 8),
          Text('Logged in as: ', style: ShadTheme.of(context).textTheme.muted),
          Text(
            userRole.toUpperCase(),
            style: ShadTheme.of(context).textTheme.table,
          ),
        ],
      ),
    );
  }

  bool _hasAccess(List<UserRole> requiredRoles, UserRole userRole) {
    return requiredRoles.contains(userRole);
  }
}
