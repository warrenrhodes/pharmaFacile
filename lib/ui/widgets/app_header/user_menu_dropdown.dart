import 'package:flutter/material.dart';
import 'package:pharmacie_stock/config/internationalizations/internationalization.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../models/user.dart';

class UserMenuDropdown extends StatelessWidget {
  final User? user;
  final VoidCallback onLogout;
  final popoverController = ShadPopoverController();

  UserMenuDropdown({super.key, required this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadPopover(
      controller: popoverController,
      child: InkWell(
        onTap: popoverController.toggle,
        child: Row(
          children: [
            const Icon(LucideIcons.user400, size: 20),
            const SizedBox(width: 8),
            Text(user?.name ?? 'Guest', style: theme.textTheme.large),
            const SizedBox(width: 4),
            const Icon(LucideIcons.chevronDown400, size: 20),
          ],
        ),
      ),
      popover: (context) => SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(user?.name ?? 'Guest', style: theme.textTheme.large),
            const SizedBox(height: 4),
            Text(
              user?.role.name.toUpperCase() ?? 'GUEST',
              style: theme.textTheme.muted,
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                onLogout();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.logOut400,
                      color: ShadTheme.of(context).colorScheme.destructive,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.select<Internationalization, String>(
                        (e) => e.logout,
                      ),
                      style: theme.textTheme.lead.copyWith(
                        color: ShadTheme.of(context).colorScheme.destructive,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
