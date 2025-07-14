import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:pharmacie_stock/models/user.dart';
import 'package:pharmacie_stock/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class UserFormDialog extends StatefulWidget {
  final User? user;

  const UserFormDialog({super.key, this.user});

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  final _formKey = GlobalKey<ShadFormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  UserRole _selectedRole = UserRole.assistant;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _selectedRole = widget.user!.role;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: Text(widget.user == null ? 'Add New User' : 'Edit User'),
      child: Material(
        child: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: ShadForm(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user == null
                        ? 'Create a new user account'
                        : 'Update user information and permissions',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // Full Name
                  ShadInputFormField(
                    id: 'name',
                    label: const Text('Full Name *'),
                    controller: _nameController,
                    placeholder: const Text('Enter full name'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email Address
                  ShadInputFormField(
                    id: 'email',
                    label: const Text('Email Address *'),
                    controller: _emailController,
                    placeholder: const Text('Enter email address'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Email address is required';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password (only for new users)
                  if (widget.user == null) ...[
                    ShadInputFormField(
                      id: 'password',
                      label: const Text('Password *'),
                      controller: _passwordController,
                      placeholder: const Text('Enter password'),
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Role Selection
                  const Text(
                    'Role *',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: UserRole.values.map((role) {
                        return RadioListTile<UserRole>(
                          title: Row(
                            children: [
                              Icon(
                                _getRoleIcon(role),
                                size: 20,
                                color: _getRoleColor(role),
                              ),
                              const SizedBox(width: 8),
                              Text(role.name),
                            ],
                          ),
                          subtitle: Text(
                            _getRoleDescription(role),
                            style: const TextStyle(fontSize: 12),
                          ),
                          value: role,
                          groupValue: _selectedRole,
                          onChanged: (value) =>
                              setState(() => _selectedRole = value!),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ShadButton.outline(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ShadButton(
                        onPressed: _isLoading ? null : _saveUser,
                        child: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.user == null
                                    ? 'Add User'
                                    : 'Update User',
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
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

  String _getRoleDescription(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Full system access - Manage users, suppliers, and all operations';
      case UserRole.pharmacist:
        return 'Manage stock & sales - Handle inventory and process transactions';
      case UserRole.assistant:
        return 'Limited access - Process sales and view product information';
    }
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.saveAndValidate()) return;

    setState(() => _isLoading = true);

    try {
      final user = User(
        id: widget.user?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: _selectedRole,
        passwordHash: '123456',
        createdAtInUtc: widget.user?.createdAtInUtc ?? clock.now(),
        permissions: [],
      );

      final authProvider = context.read<AuthProvider>();

      if (widget.user == null) {
        // Add new user
        // await authProvider.addUser(user, _passwordController.text);
      } else {
        // Update existing user
        // await authProvider.updateUser(user);
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ShadToaster.of(context).show(
          ShadToast(
            title: const Text('Success'),
            description: Text(
              widget.user == null
                  ? 'User added successfully'
                  : 'User updated successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Error'),
            description: Text('Failed to save user: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
