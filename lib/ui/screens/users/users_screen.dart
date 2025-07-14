import 'package:flutter/material.dart';
import 'package:pharmacie_stock/models/user.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'components/users_form_dialogue.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    final users = appProvider.users;

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final currentUser = auth.currentUser;
        if (currentUser == null) {
          return const SizedBox();
        }

        final statsCard = [
          _buildStatCard(
            'Total Users',
            users.length.toString(),
            'Active accounts',
            LucideIcons.users,
            Colors.blue,
          ),
          _buildStatCard(
            'Administrators',
            users.where((u) => u.role == UserRole.admin).length.toString(),
            'Full access users',
            LucideIcons.shield,
            Colors.red,
          ),
          _buildStatCard(
            'Staff Members',
            users.where((u) => u.role != UserRole.admin).length.toString(),
            'Pharmacists & assistants',
            LucideIcons.user,
            Colors.green,
          ),
        ];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Management',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage system users and permissions',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  ShadButton(
                    onPressed: () => _showUserDialog(context, null),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.plus, size: 16),
                        SizedBox(width: 8),
                        Text('Add User'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              LayoutBuilder(
                builder: (context, constraints) {
                  int columns = (constraints.maxWidth / 250).floor();
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 150,
                    ),
                    itemCount: statsCard.length,
                    itemBuilder: (context, index) {
                      final statCart = statsCard[index];
                      return statCart;
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              // Users Table
              ShadCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(LucideIcons.users, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'System Users',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Manage user accounts and permissions',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('User')),
                            DataColumn(label: Text('Role')),
                            DataColumn(label: Text('Permissions')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: users.map((user) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.blue.withValues(
                                          alpha: .1,
                                        ),
                                        child: Text(
                                          user.name[0].toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                user.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              if (user.id ==
                                                  currentUser.id) ...[
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    'You',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          Text(
                                            user.email,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getRoleColor(
                                        user.role,
                                      ).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getRoleIcon(user.role),
                                          size: 12,
                                          color: _getRoleColor(user.role),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          user.role.name,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _getRoleColor(user.role),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    _getPermissionText(user.role),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Active',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          LucideIcons.squarePen400,
                                          size: 16,
                                        ),
                                        onPressed: () =>
                                            _showUserDialog(context, user),
                                      ),
                                      if (user.id != currentUser.id)
                                        IconButton(
                                          icon: const Icon(
                                            LucideIcons.trash2,
                                            size: 16,
                                          ),
                                          onPressed: () =>
                                              _showDeleteDialog(context, user),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Role Permissions Info
              ShadCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Role Permissions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Understanding user roles and their capabilities',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          int columns = (constraints.maxWidth / 250).floor();
                          final rolesPermission = [
                            _buildRoleCard(UserRole.admin),
                            _buildRoleCard(UserRole.assistant),
                            _buildRoleCard(UserRole.pharmacist),
                          ];
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  mainAxisExtent: 200,
                                ),
                            itemCount: rolesPermission.length,
                            itemBuilder: (context, index) {
                              final role = rolesPermission[index];
                              return role;
                            },
                          );
                        },
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

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, size: 20, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(UserRole role) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            children: [
              Icon(_getRoleIcon(role), size: 20, color: _getRoleColor(role)),
              const SizedBox(width: 8),
              Text(
                role.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (role == UserRole.admin) ...[
            Text(
              '• ${_getPermissionDescription(PermissionType.inventory)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              '• ${_getPermissionDescription(PermissionType.updateSettings)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              '• ${_getPermissionDescription(PermissionType.sales)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              '• ${_getPermissionDescription(PermissionType.reports)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
          if (role == UserRole.assistant) ...[
            Text(
              '• ${_getPermissionDescription(PermissionType.sales)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
          if (role == UserRole.pharmacist) ...[
            Text(
              '• ${_getPermissionDescription(PermissionType.inventory)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              '• ${_getPermissionDescription(PermissionType.sales)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              '• ${_getPermissionDescription(PermissionType.reports)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return LucideIcons.shield;
      case UserRole.pharmacist:
        return LucideIcons.user;
      case UserRole.assistant:
        return LucideIcons.users;
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.pharmacist:
        return Colors.green;
      case UserRole.assistant:
        return Colors.orange;
    }
  }

  String _getPermissionText(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Full system access';
      case UserRole.pharmacist:
        return 'Stock & sales management';
      case UserRole.assistant:
        return 'Sales only';
    }
  }

  String _getPermissionDescription(PermissionType permission) {
    switch (permission) {
      case PermissionType.inventory:
        return 'Manage inventory';
      case PermissionType.sales:
        return 'Process sales';
      case PermissionType.reports:
        return 'View reports';
      case PermissionType.updateSettings:
        return 'Update settings';
    }
  }

  void _showUserDialog(BuildContext context, User? user) {
    showDialog(
      context: context,
      builder: (context) => UserFormDialog(user: user),
    );
  }

  void _showDeleteDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Delete User'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to delete "${user.name}"? This action cannot be undone.',
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
                  onPressed: () {
                    // TODO: Implement user deletion
                    Navigator.of(context).pop();
                    ShadToaster.of(context).show(
                      const ShadToast(
                        title: Text('Success'),
                        description: Text('User deleted successfully'),
                      ),
                    );
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
