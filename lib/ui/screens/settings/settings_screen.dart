import 'package:flutter/material.dart';
import 'package:pharmacie_stock/config/internationalizations/internationalization.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/providers/auth_provider.dart';
import 'package:pharmacie_stock/utils/app_theme_provider.dart';
import 'package:pharmacie_stock/utils/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _autoBackup = true;
  String _backupFrequency = 'daily';
  int _lowStockThreshold = 10;
  int _expiryWarningDays = 30;

  @override
  void initState() {
    _loadSettings();

    super.initState();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode =
          context.watch<AppThemeProvider>().currentTheme == ThemeMode.dark;

      _notifications = prefs.getBool('notifications') ?? true;
      _autoBackup = prefs.getBool('auto_backup') ?? true;
      _backupFrequency = prefs.getString('backup_frequency') ?? 'daily';
      _lowStockThreshold = prefs.getInt('low_stock_threshold') ?? 10;
      _expiryWarningDays = prefs.getInt('expiry_warning_days') ?? 30;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _darkMode);
    await prefs.setBool('notifications', _notifications);
    await prefs.setBool('auto_backup', _autoBackup);
    await prefs.setString('backup_frequency', _backupFrequency);
    await prefs.setInt('low_stock_threshold', _lowStockThreshold);
    await prefs.setInt('expiry_warning_days', _expiryWarningDays);

    if (mounted) {
      ShadToaster.of(context).show(
        const ShadToast(
          title: Text('Settings Saved'),
          description: Text('Your preferences have been updated'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.watch<Internationalization>();
    final isDevice = ResponsiveUtils.isMobile(context);

    return Consumer2<AuthProvider, AppProvider>(
      builder: (context, auth, inventory, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Manage your application preferences and system settings',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // User Profile Section
              ShadCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(LucideIcons.user, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'User Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            child: Text(
                              auth.currentUser?.name[0].toUpperCase() ?? 'U',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  auth.currentUser?.name ?? 'Unknown User',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  auth.currentUser?.email ?? '',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    auth.currentUser?.role.name ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ShadButton.outline(
                            onPressed: () => _showChangePasswordDialog(),
                            child: const Text('Change Password'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Application Settings
              ShadCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(LucideIcons.settings, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Application Settings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Dark Mode
                      Flex(
                        direction: isDevice ? Axis.vertical : Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Expanded(
                            flex: isDevice ? 0 : 1,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dark Mode',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Switch between light and dark themes',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _darkMode,
                            onChanged: (value) {
                              setState(() => _darkMode = value);
                              _saveSettings();
                              context.read<AppThemeProvider>().setTheme(
                                value == true
                                    ? ThemeMode.dark
                                    : ThemeMode.light,
                              );
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      Flex(
                        direction: isDevice ? Axis.vertical : Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Expanded(
                            flex: isDevice ? 0 : 1,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Language',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Switch between  the language',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ShadSelect<Locale>(
                            placeholder: const Text('Select a language'),
                            options: const [
                              ShadOption(
                                value: Locale('fr'),
                                child: Text('French'),
                              ),
                              ShadOption(
                                value: Locale('en'),
                                child: Text('English'),
                              ),
                            ],
                            selectedOptionBuilder: (context, value) => Text(
                              value == const Locale('fr')
                                  ? 'French'
                                  : 'English',
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                intl.setLocale(value);
                              }
                            },
                          ),
                        ],
                      ),
                      const Divider(),

                      // Notifications
                      Flex(
                        direction: isDevice ? Axis.vertical : Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Expanded(
                            flex: isDevice ? 0 : 1,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Notifications',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Receive alerts for low stock and expiring products',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _notifications,
                            onChanged: (value) {
                              setState(() => _notifications = value);
                              _saveSettings();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Inventory Settings
              ShadCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(LucideIcons.package, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Inventory Settings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Low Stock Threshold
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Low Stock Threshold',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            'Alert when product quantity falls below this number',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 200,
                            child: ShadInput(
                              initialValue: _lowStockThreshold.toString(),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final threshold = int.tryParse(value) ?? 10;
                                setState(() => _lowStockThreshold = threshold);
                                _saveSettings();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Expiry Warning Days
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Expiry Warning (Days)',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            'Alert when products expire within this many days',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 200,
                            child: ShadInput(
                              initialValue: _expiryWarningDays.toString(),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final days = int.tryParse(value) ?? 30;
                                setState(() => _expiryWarningDays = days);
                                _saveSettings();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Backup & Data
              ShadCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(LucideIcons.database, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Backup & Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Auto Backup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Automatic Backup',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Automatically backup your data',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: _autoBackup,
                            onChanged: (value) {
                              setState(() => _autoBackup = value);
                              _saveSettings();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Backup Frequency
                      if (_autoBackup) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Backup Frequency',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 200,
                              child: ShadSelect<String>(
                                placeholder: const Text('Select frequency'),
                                options: const [
                                  ShadOption(
                                    value: 'daily',
                                    child: Text('Daily'),
                                  ),
                                  ShadOption(
                                    value: 'weekly',
                                    child: Text('Weekly'),
                                  ),
                                  ShadOption(
                                    value: 'monthly',
                                    child: Text('Monthly'),
                                  ),
                                ],
                                selectedOptionBuilder: (context, value) => Text(
                                  value == 'daily'
                                      ? 'Daily'
                                      : value == 'weekly'
                                      ? 'Weekly'
                                      : 'Monthly',
                                ),
                                onChanged: (value) {
                                  setState(
                                    () => _backupFrequency = value ?? 'daily',
                                  );
                                  _saveSettings();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Manual Backup Actions
                      Row(
                        children: [
                          ShadButton.outline(
                            onPressed: _createBackup,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.download, size: 16),
                                SizedBox(width: 8),
                                Text('Create Backup'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          ShadButton.outline(
                            onPressed: _restoreBackup,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.upload, size: 16),
                                SizedBox(width: 8),
                                Text('Restore Backup'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // System Information
              ShadCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(LucideIcons.info, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'System Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildInfoRow('Application Version', '1.0.0'),
                      _buildInfoRow('Database Version', '1.0'),
                      _buildInfoRow(
                        'Total Products',
                        inventory.products.length.toString(),
                      ),
                      // _buildInfoRow(
                      //   'Total Users',
                      //   auth.users.length.toString(),
                      // ),
                      _buildInfoRow(
                        'Total Suppliers',
                        inventory.suppliers.length.toString(),
                      ),
                      _buildInfoRow('Last Backup', 'Never'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Danger Zone
              ShadCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            LucideIcons.triangleAlert400,
                            size: 20,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Danger Zone',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'These actions are irreversible. Please proceed with caution.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          ShadButton.outline(
                            onPressed: _clearAllData,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.trash2,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Clear All Data',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          ShadButton.outline(
                            onPressed: _resetToDefaults,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.rotateCcw400,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Reset to Defaults',
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Change Password'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Password change functionality would be implemented here.',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShadButton.outline(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ShadButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Update Password'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createBackup() async {
    // TODO: Implement backup creation
    ShadToaster.of(context).show(
      const ShadToast(
        title: Text('Backup Created'),
        description: Text('Your data has been backed up successfully'),
      ),
    );
  }

  Future<void> _restoreBackup() async {
    // TODO: Implement backup restoration
    ShadToaster.of(context).show(
      const ShadToast(
        title: Text('Backup Restored'),
        description: Text('Your data has been restored successfully'),
      ),
    );
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Clear All Data'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Are you sure you want to clear all data? This action cannot be undone.',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShadButton.outline(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ShadButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Clear All Data'),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      // TODO: Implement data clearing
      ShadToaster.of(context).show(
        const ShadToast.destructive(
          title: Text('Data Cleared'),
          description: Text('All data has been cleared from the system'),
        ),
      );
    }
  }

  Future<void> _resetToDefaults() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Reset to Defaults'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Are you sure you want to reset all settings to their default values?',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShadButton.outline(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ShadButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      setState(() {
        _darkMode = false;
        _notifications = true;
        _autoBackup = true;
        _backupFrequency = 'daily';
        _lowStockThreshold = 10;
        _expiryWarningDays = 30;
      });
      await _saveSettings();

      ShadToaster.of(context).show(
        const ShadToast(
          title: Text('Settings Reset'),
          description: Text('All settings have been reset to default values'),
        ),
      );
    }
  }
}
