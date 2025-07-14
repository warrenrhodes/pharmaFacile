import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  String? error;
  final TextEditingController _pinController = TextEditingController();
  bool _showPin = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final pin = _pinController.text.trim();
      if (pin.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 1));
        // ref.read(authProvider.notifier).signIn();
      }
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFDDEFFF), // blue-100
              Color(0xFFFFFFFF), // white
              Color(0xFFDCFCE7), // green-100
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40.0),
              child: ShadCard(
                radius: const BorderRadius.all(Radius.circular(20)),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header Section
                        Column(
                          children: [
                            // Logo Container
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF3B82F6), // blue-500
                                    Color(0xFF2563EB), // blue-600
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                LucideIcons.user,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Title
                            const Text(
                              'PharmaFacile',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937), // gray-800
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Subtitle
                            const Text(
                              'Système de Gestion de Pharmacie',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF6B7280), // gray-600
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Connection prompt
                            const Text(
                              'Connectez-vous pour continuer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2563EB), // blue-600
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Form Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // PIN Input Label
                            const Text(
                              'Code PIN ou Mot de passe',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151), // gray-700
                              ),
                            ),
                            const SizedBox(height: 16),

                            // PIN Input Field
                            ShadInputFormField(
                              controller: _pinController,
                              placeholderAlignment: Alignment.centerLeft,
                              placeholder: const Text('Entrez votre code PIN'),
                              obscureText: !_showPin,
                              autofocus: true,
                              leading: const Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Icon(
                                  Icons.lock_outline,
                                  size: 24,
                                  color: Color(0xFF9CA3AF), // gray-400
                                ),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showPin = !_showPin;
                                    });
                                  },
                                  child: Icon(
                                    _showPin
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 24,
                                    color: const Color(0xFF9CA3AF), // gray-400
                                  ),
                                ),
                              ),
                              style: const TextStyle(fontSize: 20),
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'Veuillez entrer votre code PIN';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Error Message
                        if (error != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 32),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2), // red-50
                              border: Border.all(
                                color: const Color(0xFFFECACA), // red-200
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '❌ $error',
                              style: const TextStyle(
                                color: Color(0xFFB91C1C), // red-700
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                        // Submit Button
                        ShadButton(
                          onPressed: _handleSubmit,
                          width: double.infinity,
                          height: 60,
                          backgroundColor: const Color(0xFF3B82F6), // blue-500
                          hoverBackgroundColor: const Color(
                            0xFF2563EB,
                          ), // blue-600
                          child: const Text(
                            '🔓 Se connecter',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Demo Codes Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF), // blue-50
                            border: Border.all(
                              color: const Color(0xFFBFDBFE), // blue-200
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            children: [
                              Text(
                                '🔑 Codes de Démonstration:',
                                style: TextStyle(
                                  color: Color(0xFF1E3A8A), // blue-800
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Administrateur: 1234',
                                style: TextStyle(
                                  color: Color(0xFF1D4ED8), // blue-700
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Assistant: 5678',
                                style: TextStyle(
                                  color: Color(0xFF1D4ED8), // blue-700
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
