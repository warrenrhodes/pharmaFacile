import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

class LowStockProduct {
  final String name;
  final int quantity;

  const LowStockProduct({required this.name, required this.quantity});

  @override
  String toString() => '$name ($quantity)';
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String description;
  final List<Color> gradientColors;
  final String routeName;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.description,
    required this.gradientColors,
    required this.routeName,
  });
}

/// Navigation items configuration
const List<NavigationItem> homeNavigationItems = [
  NavigationItem(
    icon: Icons.shopping_cart,
    label: 'Nouvelle Vente',
    description: 'Enregistrer une nouvelle transaction de vente',
    gradientColors: AppColors.blueGradient,
    routeName: '/sales',
  ),
  NavigationItem(
    icon: Icons.inventory_2,
    label: 'Stock Produits',
    description: 'Gérer l\'inventaire et les stocks',
    gradientColors: AppColors.greenGradient,
    routeName: '/stock',
  ),
  NavigationItem(
    icon: Icons.bar_chart,
    label: 'Rapports',
    description: 'Consulter les statistiques de vente',
    gradientColors: AppColors.purpleGradient,
    routeName: '/reports',
  ),
  NavigationItem(
    icon: Icons.settings,
    label: 'Paramètres',
    description: 'Configuration et sauvegarde',
    gradientColors: AppColors.grayGradient,
    routeName: '/settings',
  ),
];
