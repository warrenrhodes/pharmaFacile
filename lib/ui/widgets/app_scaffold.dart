import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const AppScaffold({
    super.key,
    required this.body,
    this.currentIndex = 0,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabSelected,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Ventes'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stock'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Rapports'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Paramètres'),
        ],
      ),
    );
  }
}
