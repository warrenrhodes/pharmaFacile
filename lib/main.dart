import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacie_stock/firebase/firebase_init.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'providers/auth_provider.dart';
import 'ui/screens/auth_screen.dart';
import 'ui/screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeFirebaseApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;
    return ShadApp(
      themeMode: ThemeMode.light,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadBlueColorScheme.light(),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadBlueColorScheme.dark(),
      ),
      builder: (context, __) {
        return MaterialApp(
          title: 'PharmaFacile',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              secondary: Colors.blueAccent,
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            cardTheme: CardThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            buttonTheme: ButtonThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              buttonColor: Colors.blue,
            ),
            fontFamily: 'Inter',
          ),
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: isAuthenticated ? const AuthScreen() : const DashboardScreen(),
        );
      },
    );
  }
}
