import 'package:flutter/material.dart';
import 'package:pharmacie_stock/models/product.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProductFormProvider extends ChangeNotifier {
  ProductFormProvider(this._product) {
    _initializeControllers();
  }

  final Product? _product;

  final formKey = GlobalKey<ShadFormState>();
  final nameController = TextEditingController();
  final barcodeController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final reorderThresholdController = TextEditingController();
  final expiryController = TextEditingController();

  // Selection states
  String? _selectedCategoryId;
  String? _selectedSupplierId;
  bool _isLoading = false;

  // Getters
  String? get selectedCategoryId => _selectedCategoryId;
  String? get selectedSupplierId => _selectedSupplierId;
  bool get isLoading => _isLoading;

  void _initializeControllers() {
    if (_product != null) {
      nameController.text = _product.name;
      barcodeController.text = _product.barcode;
      priceController.text = _product.price.toString();
      quantityController.text = _product.quantity.toString();
      reorderThresholdController.text = _product.reorderThreshold.toString();
      expiryController.text = _product.expiryDate.toIso8601String().split(
        'T',
      )[0];
      _selectedCategoryId = _product.categoryId;
      _selectedSupplierId = _product.supplierId;
    }
  }

  void updateBarcode(String barcode) {
    barcodeController.text = barcode;
    notifyListeners();
  }

  void updateSelectedCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void updateSelectedSupplier(String? supplierId) {
    _selectedSupplierId = supplierId;
    notifyListeners();
  }

  void updateExpiryDate(DateTime date) {
    expiryController.text = date.toIso8601String().split('T')[0];
    notifyListeners();
  }

  DateTime getInitialExpiryDate() {
    if (_product?.expiryDate != null) {
      return _product!.expiryDate;
    }
    return DateTime.now().add(const Duration(days: 365));
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  bool validateForm() {
    return formKey.currentState?.saveAndValidate() ?? false;
  }

  bool validateSelections() {
    return _selectedCategoryId != null && _selectedSupplierId != null;
  }

  Product createProduct() {
    return Product(
      id: _product?.id ?? '',
      name: nameController.text,
      barcode: barcodeController.text,
      categoryId: _selectedCategoryId!,
      price: double.tryParse(priceController.text) ?? 0.0,
      quantity: int.tryParse(quantityController.text) ?? 0,
      reorderThreshold: int.tryParse(reorderThresholdController.text) ?? 0,
      expiryDate: DateTime.parse(expiryController.text),
      supplierId: _selectedSupplierId!,
      createdAtInUtc: _product?.createdAtInUtc ?? DateTime.now(),
      updatedAtInUtc: DateTime.now(),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    barcodeController.dispose();
    priceController.dispose();
    quantityController.dispose();
    reorderThresholdController.dispose();
    expiryController.dispose();
    super.dispose();
  }
}
