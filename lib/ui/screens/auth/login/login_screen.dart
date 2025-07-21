import 'package:flutter/material.dart';
import 'package:pharmacie_stock/providers/auth_provider.dart';
import 'package:pharmacie_stock/utils/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../forgot_password/forgot_password.dart';
import '../registration/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
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
                        Expanded(child: Image.asset('assets/images/login.png')),
                      Expanded(
                        child: ShadCard(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Logo/Icon
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF6366F1),
                                        Color(0xFF8B5CF6),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    LucideIcons.lockKeyhole400,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Title
                                Text('Welcome Back', style: theme.textTheme.h4),
                                const SizedBox(height: 8),
                                Text(
                                  'Sign in to your account',
                                  style: theme.textTheme.p,
                                ),
                                const SizedBox(height: 32),

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
                                const SizedBox(height: 24),

                                // Error Message
                                Consumer<AuthProvider>(
                                  builder: (context, auth, child) {
                                    if (auth.errorMessage != null) {
                                      return ShadAlert.destructive(
                                        iconData: LucideIcons.circleAlert400,
                                        description: Text(
                                          auth.errorMessage!,
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),

                                // Login Button
                                Consumer<AuthProvider>(
                                  builder: (context, auth, child) {
                                    return ShadButton(
                                      onPressed:
                                          auth.status ==
                                              AuthStatus.authenticating
                                          ? null
                                          : () => auth.login(
                                              _emailController.text,
                                              _passwordController.text,
                                            ),
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
                                          : const Text('Sign In'),
                                    );
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Forgot Password
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                            ) => const ForgotPasswordScreen(),
                                        transitionsBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                              child,
                                            ) {
                                              return SlideTransition(
                                                position: animation.drive(
                                                  Tween(
                                                    begin: const Offset(
                                                      1.0,
                                                      0.0,
                                                    ),
                                                    end: Offset.zero,
                                                  ),
                                                ),
                                                child: child,
                                              );
                                            },
                                      ),
                                    );
                                  },
                                  child: const Text('Forgot Password?'),
                                ),

                                const SizedBox(height: 24),

                                // Sign Up Link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Don't have an account? "),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                ) => const RegisterScreen(),
                                            transitionsBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child,
                                                ) {
                                                  return SlideTransition(
                                                    position: animation.drive(
                                                      Tween(
                                                        begin: const Offset(
                                                          1.0,
                                                          0.0,
                                                        ),
                                                        end: Offset.zero,
                                                      ),
                                                    ),
                                                    child: child,
                                                  );
                                                },
                                          ),
                                        );
                                      },
                                      child: const Text('Sign Up'),
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
