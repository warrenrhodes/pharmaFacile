import 'package:flutter/material.dart';
import 'package:pharmacie_stock/models/user.dart';
import 'package:pharmacie_stock/providers/auth_provider.dart';
import 'package:pharmacie_stock/utils/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF10B981), Color(0xFF059669), Color(0xFF047857)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      if (ResponsiveUtils.isDesktop(context))
                        Expanded(
                          child: Image.asset('assets/images/signup.png'),
                        ),
                      Expanded(
                        child: ShadCard(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Back Button
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(LucideIcons.arrowLeft),
                                    ),
                                  ],
                                ),

                                // Logo/Icon
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF10B981),
                                        Color(0xFF059669),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    LucideIcons.userRoundPlus400,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Title
                                Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Join us today',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Name Field
                                ShadInputFormField(
                                  controller: _nameController,
                                  placeholder: const Text('Full Name'),
                                  trailing: const Icon(LucideIcons.user400),
                                ),
                                const SizedBox(height: 16),

                                // Email Field
                                ShadInputFormField(
                                  controller: _emailController,
                                  placeholder: const Text('Email'),
                                  keyboardType: TextInputType.emailAddress,
                                  trailing: const Icon(LucideIcons.mail400),
                                ),
                                const SizedBox(height: 16),

                                // Password Field
                                ShadInputFormField(
                                  controller: _passwordController,
                                  placeholder: const Text('Password'),
                                  obscureText: true,
                                  trailing: const Icon(
                                    LucideIcons.lockKeyhole400,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Confirm Password Field
                                ShadInputFormField(
                                  controller: _confirmPasswordController,
                                  placeholder: const Text('Confirm Password'),
                                  obscureText: true,
                                  trailing: const Icon(
                                    LucideIcons.lockKeyhole400,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Error Message
                                Consumer<AuthProvider>(
                                  builder: (context, auth, child) {
                                    if (auth.errorMessage != null) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.red.shade200,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              LucideIcons.circleAlert400,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                auth.errorMessage!,
                                                style: TextStyle(
                                                  color: Colors.red.shade700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),

                                // Register Button
                                Consumer<AuthProvider>(
                                  builder: (context, auth, child) {
                                    return ShadButton(
                                      onPressed:
                                          auth.status ==
                                              AuthStatus.authenticating
                                          ? null
                                          : () {
                                              if (_passwordController.text !=
                                                  _confirmPasswordController
                                                      .text) {
                                                ShadToaster.of(context).show(
                                                  const ShadToast(
                                                    title: Text(
                                                      'Passwords do not match',
                                                    ),
                                                  ),
                                                );

                                                return;
                                              }
                                              auth.register(
                                                name: _nameController.text,
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                                role: UserRole.admin,
                                                permissions: [
                                                  PermissionType.inventory,
                                                  PermissionType.reports,
                                                  PermissionType.sales,
                                                ],
                                              );
                                            },
                                      width: double.infinity,
                                      child:
                                          auth.status ==
                                              AuthStatus.authenticating
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : const Text('Create Account'),
                                    );
                                  },
                                ),

                                const SizedBox(height: 24),

                                // Terms and Conditions
                                Text(
                                  'By creating an account, you agree to our Terms of Service and Privacy Policy',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Sign In Link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Already have an account? "),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Sign In'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
