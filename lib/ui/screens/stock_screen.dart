import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacie_stock/ui/screens/add_product.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/product_model.dart';
import '../../providers/product_provider.dart';

class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key});

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _editingProductId;
  String _newStock = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'F',
      decimalDigits: 0,
    ).format(amount);
  }

  void _startEditStock(Product product) {
    setState(() {
      _editingProductId = product.id;
      _newStock = product.stock.toString();
    });
  }

  void _cancelEditStock() {
    setState(() {
      _editingProductId = null;
      _newStock = '';
    });
  }

  Future<void> _saveEditStock(Product product) async {
    final stock = int.tryParse(_newStock);
    if (stock == null || stock < 0) return;
    final updated = product.copyWith(stock: stock, updatedAt: DateTime.now());
    await ref.read(productListProvider.notifier).updateProduct(updated);
    setState(() {
      _editingProductId = null;
      _newStock = '';
    });
  }

  Map<String, dynamic> _getStockStatus(Product product) {
    if (product.stock <= product.minStock) {
      return {
        'color': Colors.red[600],
        'bg': Colors.red[50],
        'border': Colors.red[200],
        'label': 'Stock Critique',
        'icon': '🔴',
      };
    }
    if (product.stock <= product.minStock * 2) {
      return {
        'color': Colors.orange[600],
        'bg': Colors.orange[50],
        'border': Colors.orange[200],
        'label': 'Stock Faible',
        'icon': '🟡',
      };
    }
    return {
      'color': Colors.green[600],
      'bg': Colors.green[50],
      'border': Colors.green[200],
      'label': 'Stock OK',
      'icon': '🟢',
    };
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListProvider);
    final searchTerm = _searchController.text.trim().toLowerCase();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEBF8FF), // blue-50
              Colors.white,
              Color(0xFFF0FFF4), // green-50
            ],
          ),
        ),
        child: SafeArea(
          child: productsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Erreur: $e')),
            data: (products) {
              final filteredProducts = products.where((p) {
                return p.name.toLowerCase().contains(searchTerm) ||
                    p.category.toLowerCase().contains(searchTerm);
              }).toList();
              final lowStockProducts = products
                  .where((p) => p.stock <= p.minStock)
                  .toList();

              return Column(
                children: [
                  // Header
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.blue.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 28,
                                  color: Colors.grey,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Stock Produits',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  Text(
                                    "Gérer l'inventaire",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF22C55E),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ShadButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddProductView(),
                              ),
                            ),
                            leading: const Icon(Icons.add, color: Colors.white),
                            child: const Text(
                              'Ajouter Produit',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Low Stock Alert
                          if (lowStockProducts.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(bottom: 32),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFFFEF2F2), // red-50
                                    Color(0xFFFFF7ED), // orange-50
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: const Border(
                                  left: BorderSide(
                                    color: Color(0xFFEF4444), // red-400
                                    width: 4,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Color(0xFFDC2626),
                                          size: 32,
                                        ),
                                        SizedBox(width: 16),
                                        Text(
                                          '🚨 Alerte Stock Critique',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFB91C1C),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${lowStockProducts.length} produit(s) nécessitent un réapprovisionnement urgent',
                                      style: const TextStyle(
                                        color: Color(0xFFDC2626),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 8,
                                      children: lowStockProducts
                                          .map(
                                            (p) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFFECACA,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                '${p.name} (Stock: ${p.stock}, Min: ${p.minStock})',
                                                style: const TextStyle(
                                                  color: Color(0xFFB91C1C),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Search
                          Container(
                            margin: const EdgeInsets.only(bottom: 32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFDBEAFE),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: (_) => setState(() {}),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            'Rechercher un produit par nom ou catégorie...',
                                        hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Products Grid
                          if (filteredProducts.isNotEmpty)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    // crossAxisCount: 4,
                                    maxCrossAxisExtent: 450,
                                    mainAxisSpacing: 24,
                                    crossAxisSpacing: 24,
                                  ),
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, idx) {
                                final product = filteredProducts[idx];
                                final stockStatus = _getStockStatus(product);
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: stockStatus['border'] as Color,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF1F2937),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFDBEAFE,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    product.category,
                                                    style: const TextStyle(
                                                      color: Color(0xFF2563EB),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                if (product.description !=
                                                        null &&
                                                    product
                                                        .description!
                                                        .isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 6.0,
                                                        ),
                                                    child: Text(
                                                      product.description!,
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: stockStatus['bg'] as Color,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color:
                                                    stockStatus['border']
                                                        as Color,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  stockStatus['icon'] as String,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  stockStatus['label']
                                                      as String,
                                                  style: TextStyle(
                                                    color:
                                                        stockStatus['color']
                                                            as Color,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFDCFCE7),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFBBF7D0,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Prix de Vente',
                                                    style: TextStyle(
                                                      color: Color(0xFF22C55E),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    _formatCurrency(
                                                      product.sellingPrice,
                                                    ),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Color(0xFF16A34A),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF1F5F9),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFE5E7EB,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Prix d'Achat",
                                                    style: TextStyle(
                                                      color: Color(0xFF64748B),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    _formatCurrency(
                                                      product.purchasePrice,
                                                    ),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Color(0xFF334155),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      const Divider(
                                        height: 1,
                                        color: Color(0xFFE5E7EB),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Stock Actuel',
                                                  style: TextStyle(
                                                    color: Color(0xFF64748B),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                if (_editingProductId ==
                                                    product.id)
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 60,
                                                        child: TextField(
                                                          autofocus: true,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration: const InputDecoration(
                                                            isDense: true,
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                  vertical: 8,
                                                                  horizontal: 8,
                                                                ),
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                          onChanged: (v) =>
                                                              setState(
                                                                () =>
                                                                    _newStock =
                                                                        v,
                                                              ),
                                                          controller:
                                                              TextEditingController(
                                                                text: _newStock,
                                                              ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      ElevatedButton(
                                                        onPressed: () =>
                                                            _saveEditStock(
                                                              product,
                                                            ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                0xFF22C55E,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 12,
                                                                vertical: 8,
                                                              ),
                                                        ),
                                                        child: const Text(
                                                          '✓',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      ElevatedButton(
                                                        onPressed:
                                                            _cancelEditStock,
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.grey[300],
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 12,
                                                                vertical: 8,
                                                              ),
                                                        ),
                                                        child: const Text(
                                                          '✕',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                else
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${product.stock}',
                                                        style: TextStyle(
                                                          fontSize: 28,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              stockStatus['color']
                                                                  as Color,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          color: Color(
                                                            0xFF2563EB,
                                                          ),
                                                        ),
                                                        onPressed: () =>
                                                            _startEditStock(
                                                              product,
                                                            ),
                                                        tooltip:
                                                            'Modifier le stock',
                                                      ),
                                                    ],
                                                  ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 4.0,
                                                      ),
                                                  child: Text(
                                                    'Stock minimum: ${product.minStock}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                          if (filteredProducts.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 60),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inventory_2,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Aucun produit trouvé',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Essayez de modifier votre recherche',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
