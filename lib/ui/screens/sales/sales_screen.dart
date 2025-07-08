import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../models/product_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/product_provider.dart';
import 'components/cart_panel.dart';
import 'components/product_selection_panel.dart';
import 'components/sales_header.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  Product? _selectedProduct;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _quantityController.text = '1';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _handleAddToCart() {
    if (_selectedProduct == null || _quantity <= 0) return;

    if (_quantity > _selectedProduct!.stock) {
      _showErrorDialog('⚠️ Stock insuffisant pour ce produit');
      return;
    }

    try {
      ref.read(cartProvider.notifier).addToCart(_selectedProduct!, _quantity);

      setState(() {
        _selectedProduct = null;
        _searchController.clear();
        _quantity = 1;
        _quantityController.text = '1';
      });
    } catch (e) {
      _showErrorDialog('⚠️ ${e.toString()}');
    }
  }

  void _handleRemoveFromCart(String productId) {
    ref.read(cartProvider.notifier).removeFromCart(productId);
  }

  void _handleCompleteSale() {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty) return;

    ref.read(cartProvider.notifier).clearCart();

    setState(() {
      _selectedProduct = null;
      _searchController.clear();
      _quantity = 1;
      _quantityController.text = '1';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vente enregistrée avec succès!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListProvider);
    final cartItemCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
        data: (products) {
          return SafeArea(
            child: Column(
              children: [
                SalesHeader(
                  cartItemCount: cartItemCount,
                  onBackPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppConstants.maxWidth,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        AppConstants.contentPadding,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide =
                              constraints.maxWidth >
                              AppConstants.tabletBreakpoint;

                          return GridView.count(
                            crossAxisCount: isWide ? 2 : 1,
                            mainAxisSpacing: AppConstants.spacingXXL,
                            crossAxisSpacing: AppConstants.spacingXXL,
                            children: [
                              ProductSelectionPanel(
                                searchController: _searchController,
                                quantityController: _quantityController,
                                selectedProduct: _selectedProduct,
                                quantity: _quantity,
                                products: products,
                                onProductSelected: (product) {
                                  setState(() {
                                    _selectedProduct = product;
                                    _quantity = 1;
                                    _quantityController.text = '1';
                                  });
                                },
                                onQuantityChanged: (newQuantity) {
                                  setState(() {
                                    _quantity = newQuantity;
                                  });
                                },
                                onAddToCart: _handleAddToCart,
                              ),
                              CartPanel(
                                onRemoveFromCart: _handleRemoveFromCart,
                                onCompleteSale: _handleCompleteSale,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
