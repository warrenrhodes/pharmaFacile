import 'package:flutter/material.dart';
import 'package:pharmacie_stock/models/user.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MenuItem {
  final String id;
  final String label;
  final IconData icon;
  final List<UserRole> roles;
  final List<MenuItem>? children;

  MenuItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.roles,
    this.children,
  });
}

class SidebarMenuItem extends StatelessWidget {
  final MenuItem item;
  final String activeTab;
  final Function(String) onTabChange;
  final UserRole userRole;
  final bool isChild;

  const SidebarMenuItem({
    super.key,
    required this.item,
    required this.activeTab,
    required this.onTabChange,
    required this.userRole,
    this.isChild = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!_hasAccess(item.roles, userRole)) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        _buildMenuItem(context),
        if (item.children != null) ...[
          const SizedBox(height: 4),
          ...item.children!.map(
            (child) => SidebarMenuItem(
              item: child,
              activeTab: activeTab,
              onTabChange: onTabChange,
              userRole: userRole,
              isChild: true,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context) {
    final isActive = activeTab == item.id;
    final theme = ShadTheme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onTabChange(item.id),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isChild ? 32 : 16,
            vertical: isChild ? 8 : 12,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: isChild ? 18 : 20,
                color: isActive
                    ? theme.colorScheme.primaryForeground
                    : theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                item.label,
                style: ShadTheme.of(context).textTheme.p.copyWith(
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? theme.colorScheme.primaryForeground
                      : theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasAccess(List<UserRole> requiredRoles, UserRole userRole) {
    return requiredRoles.contains(userRole);
  }
}
