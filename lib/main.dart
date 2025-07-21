import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pharmacie_stock/config/internationalizations/internationalization.dart';
import 'package:pharmacie_stock/database/database.dart';
import 'package:pharmacie_stock/firebase/firebase_init.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/providers/cart_provider.dart';
import 'package:pharmacie_stock/repositories/users.dart';
import 'package:pharmacie_stock/ui/screens/auth/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'providers/auth_provider.dart';
import 'ui/screens/home/home.dart';
import 'utils/app_theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeFirebaseApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appInternationalization = Internationalization(
      const Locale('en', ''),
    );

    Locale localeListResolutionCallback(
      Iterable<Locale> supportedLocales,
      List<Locale>? systemLocales,
      Internationalization appInternationalization,
    ) {
      Locale result = supportedLocales.first;
      if (systemLocales == null || supportedLocales.length < 2) {
        return result;
      }
      final appLocales = supportedLocales.toList(growable: false);
      for (final systemLocale in systemLocales) {
        final localIndex = appLocales.indexWhere(
          (appLocale) => systemLocale.languageCode == appLocale.languageCode,
        );
        if (localIndex >= 0) {
          result = appLocales[localIndex];
          break;
        }
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appInternationalization.setLocale(result);
      });

      return result;
    }

    final Database database = Database.created(DatabaseType.appWriter);
    final UserRepository userRepository = UserRepository(database);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Internationalization>(
          create: (_) => appInternationalization,
        ),
        Provider<UserRepository>(create: (_) => userRepository),
        ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(userRepository),
        ),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<AppThemeProvider>(
          create: (_) => AppThemeProvider(),
        ),
      ],
      child: Consumer3<Internationalization, AppThemeProvider, AuthProvider>(
        builder: (_, internationalization, themeProvider, auth, __) {
          return ShadApp(
            title: 'PharmaFacile',
            themeMode: themeProvider.currentTheme,
            theme: AppThemeProvider.lightTheme,
            darkTheme: AppThemeProvider.darkTheme,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Internationalization.supportedLocales,
            localeListResolutionCallback: (systemLocales, supportedLocales) =>
                localeListResolutionCallback(
                  supportedLocales,
                  systemLocales,
                  internationalization,
                ),
            home: auth.currentUser != null
                ? const HomeScreen()
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}
