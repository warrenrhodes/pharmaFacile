import 'package:flutter/material.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../utils/responsive_utils.dart';
import 'notification_dropdown.dart';
import 'user_menu_dropdown.dart';

class HeaderWidget extends StatelessWidget {
  final VoidCallback onMenuClick;
  final bool isSidebarOpen;

  const HeaderWidget({
    super.key,
    required this.onMenuClick,
    required this.isSidebarOpen,
  });

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final isTablet = ResponsiveUtils.isTablet(context);
    final theme = ShadTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.secondary.withValues(alpha: .1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isTablet) ...[
            IconButton(
              onPressed: onMenuClick,
              icon: Icon(
                isSidebarOpen ? LucideIcons.x400 : LucideIcons.menu400,
                size: 24,
              ),
              padding: const EdgeInsets.all(8),
            ),
            const SizedBox(width: 16),
          ],
          const Spacer(),
          NotificationDropdown(
            alerts: appProvider.alerts,
            unreadCount: appProvider.unreadAlerts.length,
            onMarkAllRead: appProvider.markAllAlertsAsRead,
            onMarkAsRead: appProvider.markAlertAsRead,
          ),
          const SizedBox(width: 16),
          UserMenuDropdown(user: appProvider.currentUser, onLogout: () {}),
        ],
      ),
    );
  }
}
