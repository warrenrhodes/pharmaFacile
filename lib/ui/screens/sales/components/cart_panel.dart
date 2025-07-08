import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../models/sale_item_model.dart';
import '../../../../providers/cart_provider.dart';
import '../../../../utils/currency_formatter.dart';

class CartPanel extends ConsumerWidget {
  final Function(String) onRemoveFromCart;
  final VoidCallback onCompleteSale;

  const CartPanel({
    super.key,
    required this.onRemoveFromCart,
    required this.onCompleteSale,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartTotal = ref.watch(cartTotalProvider);

    return Column(
      spacing: 24,
      children: [
        Expanded(
          child: Container(
            constraints: const BoxConstraints(minHeight: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                if (cart.isEmpty)
                  _buildEmptyCart()
                else
                  Expanded(child: _buildCartItems(cart, cartTotal)),
              ],
            ),
          ),
        ),
        if (cart.isNotEmpty) _buildCartTotal(cartTotal),
      ],
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        Icon(Icons.shopping_cart, color: Colors.green, size: 28),
        SizedBox(width: 12),
        Text(
          'Panier de Vente',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.shopping_cart,
              size: 40,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucun article dans le panier',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sélectionnez un produit pour commencer',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(List<SaleItem> cart, double cartTotal) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: cart.length,
      itemBuilder: (context, index) {
        final item = cart[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.quantity} × ${CurrencyFormatter.formatCurrency(item.unitPrice)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.formatCurrency(item.total),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShadButton.outline(
                    onPressed: () => onRemoveFromCart(item.productId),
                    backgroundColor: Colors.red[50],
                    child: const Icon(Icons.close, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartTotal(double cartTotal) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E8), Color(0xFFE3F2FD)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total à Payer:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                CurrencyFormatter.formatCurrency(cartTotal),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: ShadButton.outline(
              expands: true,
              onPressed: onCompleteSale,
              leading: const Icon(Icons.check, size: 24),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              child: const Text(
                'Valider la Vente',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
