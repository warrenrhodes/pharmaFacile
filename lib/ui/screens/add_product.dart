import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacie_stock/models/product_model.dart';
import 'package:pharmacie_stock/providers/product_provider.dart';
import 'package:pharmacie_stock/ui/widgets/custom_button.dart';
import 'package:pharmacie_stock/ui/widgets/custom_text_field.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:uuid/uuid.dart';

class AddProductView extends ConsumerStatefulWidget {
  const AddProductView({super.key});

  @override
  ConsumerState<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends ConsumerState<AddProductView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _buyPriceController = TextEditingController();
  final _sellPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _minStockController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _category = '';
  bool _loading = false;

  final List<String> _categories = const [
    'Antidouleur',
    'Antibiotique',
    'Vitamines',
    'Rhume & Grippe',
    'Digestif',
    'Cardiologie',
    'Dermatologie',
    'Ophtalmologie',
    'Pédiatrie',
    'Autres',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _buyPriceController.dispose();
    _sellPriceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final buyPrice = double.tryParse(_buyPriceController.text.trim()) ?? 0;
    final sellPrice = double.tryParse(_sellPriceController.text.trim()) ?? 0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;
    final minStock = int.tryParse(_minStockController.text.trim()) ?? 5;
    final description = _descriptionController.text.trim();
    final category = _category;

    if (name.isEmpty ||
        buyPrice <= 0 ||
        sellPrice <= 0 ||
        stock < 0 ||
        category.isEmpty) {
      _showError(
        'Veuillez remplir tous les champs obligatoires avec des valeurs valides.',
      );
      return;
    }
    if (sellPrice <= buyPrice) {
      _showError('Le prix de vente doit être supérieur au prix d\'achat.');
      return;
    }
    setState(() => _loading = true);
    final product = Product(
      id: const Uuid().v4(),
      name: name,
      category: category,
      purchasePrice: buyPrice,
      sellingPrice: sellPrice,
      stock: stock,
      minStock: minStock,
      description: description.isEmpty ? null : description,
      createdAt: DateTime.now(),
      updatedAt: null,
    );
    try {
      await ref.read(productListProvider.notifier).addProduct(product);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _showError('Erreur lors de l\'ajout: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  double? get _margin {
    final buy = double.tryParse(_buyPriceController.text);
    final sell = double.tryParse(_sellPriceController.text);
    if (buy != null && sell != null && buy > 0) {
      return ((sell - buy) / buy) * 100;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 28),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Retour',
        ),
        title: const Text(
          'Ajouter un Produit',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Responsive grid for fields
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 500;
                          return Wrap(
                            spacing: 24,
                            runSpacing: 16,
                            children: [
                              SizedBox(
                                width: isWide
                                    ? (constraints.maxWidth / 2) - 16
                                    : double.infinity,
                                child: CustomTextField(
                                  controller: _nameController,
                                  hintText: 'Nom du Produit *',
                                ),
                              ),
                              SizedBox(
                                width: isWide
                                    ? (constraints.maxWidth / 2) - 16
                                    : double.infinity,
                                child: DropdownButtonFormField<String>(
                                  value: _category.isEmpty ? null : _category,
                                  items: _categories
                                      .map(
                                        (cat) => DropdownMenuItem(
                                          value: cat,
                                          child: Text(cat),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => _category = v ?? ''),
                                  decoration: const InputDecoration(
                                    labelText: 'Catégorie *',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Obligatoire'
                                      : null,
                                ),
                              ),
                              SizedBox(
                                width: isWide
                                    ? (constraints.maxWidth / 2) - 16
                                    : double.infinity,
                                child: CustomTextField(
                                  controller: _buyPriceController,
                                  hintText: "Prix d'Achat (F CFA) *",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(
                                width: isWide
                                    ? (constraints.maxWidth / 2) - 16
                                    : double.infinity,
                                child: CustomTextField(
                                  controller: _sellPriceController,
                                  hintText: "Prix de Vente (F CFA) *",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(
                                width: isWide
                                    ? (constraints.maxWidth / 2) - 16
                                    : double.infinity,
                                child: CustomTextField(
                                  controller: _stockController,
                                  hintText: 'Stock Initial *',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(
                                width: isWide
                                    ? (constraints.maxWidth / 2) - 16
                                    : double.infinity,
                                child: CustomTextField(
                                  controller: _minStockController,
                                  hintText: 'Stock Minimum',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _descriptionController,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Aperçu',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListenableBuilder(
                              listenable: _nameController,
                              builder: (context, value) {
                                return Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(text: 'Nom:'),
                                      TextSpan(
                                        text: _nameController.text.isEmpty
                                            ? 'Non défini'
                                            : _nameController.text,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Text(
                              'Catégorie: ${_category.isEmpty ? 'Non définie' : _category}',
                            ),
                            Text(
                              "Prix d'achat: ${_buyPriceController.text.isEmpty ? 'Non défini' : '${_buyPriceController.text} F CFA'}",
                            ),
                            Text(
                              "Prix de vente: ${_sellPriceController.text.isEmpty ? 'Non défini' : '${_sellPriceController.text} F CFA'}",
                            ),
                            Text(
                              'Stock initial: ${_stockController.text.isEmpty ? 'Non défini' : _stockController.text}',
                            ),
                            Text(
                              'Stock minimum: ${_minStockController.text.isEmpty ? '5' : _minStockController.text}',
                            ),
                            if (_margin != null)
                              Text(
                                'Marge: ${_margin!.toStringAsFixed(1)}%',
                                style: const TextStyle(color: Colors.blue),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            onPressed: _loading
                                ? null
                                : () => Navigator.of(context).pop(),
                            size: ShadButtonSize.lg,
                            child: const Text('Annuler'),
                          ),
                          const SizedBox(width: 16),
                          CustomButton(
                            onPressed: _loading ? null : _handleSubmit,
                            loading: _loading,
                            size: ShadButtonSize.lg,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.save, size: 20),
                                SizedBox(width: 8),
                                Text('Ajouter le Produit'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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
