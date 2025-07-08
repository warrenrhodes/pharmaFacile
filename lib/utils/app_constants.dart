// lib/constants/app_constants.dart
class AppConstants {
  // UI Constants
  static const double maxWidth = 1200.0;
  static const double headerPadding = 50.0;
  static const double contentPadding = 16.0;
  static const double cardRadius = 28.0;
  static const double iconSize = 32.0;
  static const double headerIconSize = 64.0;
  static const double cardIconSize = 80.0;
  static const double smallIconSize = 48.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 24.0;
  static const double spacingXXL = 32.0;
  static const double spacingLarge = 40.0;

  // Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 700.0;

  // Animation
  static const Duration animationDuration = Duration(milliseconds: 200);

  // Text
  static const String appName = 'PharmaFacile';
  static const String appSubtitle = 'Gestion de Pharmacie';
  static const String userLabel = 'Connecté: Assistant';
  static const String lowStockAlertTitle = '⚠️ Attention - Stocks Faibles';
  static const String todaysSalesLabel = 'Ventes d\'aujourd\'hui';
  static const String lowStockLabel = 'Produits en stock faible';
  static const String totalProductsPrefix = 'Sur ';
  static const String totalProductsSuffix = ' produits total';
  static const String transactionsSuffix = ' transaction(s)';
  static const String productsRequireRestock =
      ' produit(s) nécessitent un réapprovisionnement';
}
