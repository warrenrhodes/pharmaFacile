import 'package:flutter/material.dart';
import 'package:pharmacie_stock/utils/app_colors.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../models/alert.dart';
import '../notification_badge.dart';

class NotificationDropdown extends StatelessWidget {
  final List<Alert> alerts;
  final int unreadCount;
  final VoidCallback onMarkAllRead;
  final Function(String) onMarkAsRead;
  final popoverController = ShadPopoverController();

  NotificationDropdown({
    super.key,
    required this.alerts,
    required this.unreadCount,
    required this.onMarkAllRead,
    required this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadPopover(
      controller: popoverController,
      child: NotificationBadge(
        count: unreadCount,
        child: IconButton(
          onPressed: popoverController.toggle,
          icon: const Icon(LucideIcons.bell400),
          padding: const EdgeInsets.all(8),
        ),
      ),
      popover: (context) => SizedBox(
        width: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notifications', style: theme.textTheme.large),
                if (unreadCount > 0)
                  TextButton(
                    onPressed: () {
                      onMarkAllRead();
                      Navigator.pop(context);
                    },
                    child: Text('Mark all read', style: theme.textTheme.muted),
                  ),
              ],
            ),
            const Divider(),
            if (alerts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text('No notifications', style: theme.textTheme.muted),
                ),
              )
            else
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Column(
                    children: alerts
                        .map((alert) => _buildAlertItem(alert, context))
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(Alert alert, BuildContext context) {
    final severityColor = _getSeverityColor(alert.severity.name);
    final theme = ShadTheme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: !alert.read
            ? AppColors.cobalt.withValues(alpha: .1)
            : AppColors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: severityColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.message, style: theme.textTheme.p),
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(alert.createdAtInUtc),
                  style: theme.textTheme.muted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'high':
        return AppColors.red;
      case 'medium':
        return AppColors.warningColor;
      default:
        return AppColors.lightGreen;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
