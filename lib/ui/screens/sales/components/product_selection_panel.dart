import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../models/product_model.dart';
import '../../../../utils/currency_formatter.dart';

class ProductSelectionPanel extends StatelessWidget {
  final TextEditingController searchController;
  final TextEditingController quantityController;
  final Product? selectedProduct;
  final int quantity;
  final List<Product> products;
  final Function(Product) onProductSelected;
  final Function(int) onQuantityChanged;
  final VoidCallback onAddToCart;

  const ProductSelectionPanel({
    super.key,
    required this.searchController,
    required this.quantityController,
    required this.selectedProduct,
    required this.quantity,
    required this.products,
    required this.onProductSelected,
    required this.onQuantityChanged,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSearchField(),
            if (selectedProduct != null) ...[
              const SizedBox(height: 24),
              _buildProductDetails(),
              const SizedBox(height: 20),
              _buildQuantitySelector(),
              const SizedBox(height: 20),
              _buildTotalPreview(),
              const SizedBox(height: 20),
              _buildAddToCartButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        Icon(Icons.search, color: Colors.blue, size: 28),
        SizedBox(width: 12),
        Text(
          'Sélectionner un Produit',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nom du Produit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Autocomplete<Product>(
          displayStringForOption: (Product option) => option.name,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<Product>.empty();
            }
            return products
                .where((Product product) {
                  return product.name.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ) ||
                      product.category.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      );
                })
                .take(5);
          },
          onSelected: onProductSelected,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            searchController.value = controller.value;
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Tapez le nom du produit...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final Product option = options.elementAt(index);
                      return ListTile(
                        title: Text(
                          option.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${CurrencyFormatter.formatCurrency(option.sellingPrice)} | Stock: ${option.stock}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              option.category,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFE8F5E8)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedProduct!.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Prix: ${CurrencyFormatter.formatCurrency(selectedProduct!.sellingPrice)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Stock: ${selectedProduct!.stock}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            selectedProduct!.category,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantité',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShadButton.outline(
              onPressed: () {
                final newQuantity = (quantity - 1).clamp(
                  1,
                  selectedProduct!.stock,
                );
                onQuantityChanged(newQuantity);
                quantityController.text = newQuantity.toString();
              },
              backgroundColor: Colors.grey[100],
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 80,
              child: TextField(
                controller: quantityController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final newQuantity = int.tryParse(value) ?? 1;
                  onQuantityChanged(
                    newQuantity.clamp(1, selectedProduct!.stock),
                  );
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ShadButton.outline(
              onPressed: () {
                final newQuantity = (quantity + 1).clamp(
                  1,
                  selectedProduct!.stock,
                );
                onQuantityChanged(newQuantity);
                quantityController.text = newQuantity.toString();
              },
              backgroundColor: Colors.grey[100],
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Center(
        child: Text(
          'Total: ${CurrencyFormatter.formatCurrency(selectedProduct!.sellingPrice * quantity)}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      child: ShadButton(
        expands: true,
        onPressed: onAddToCart,
        child: const Text(
          'Ajouter au Panier',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
