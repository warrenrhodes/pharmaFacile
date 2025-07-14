import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pharmacie_stock/models/product.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/utils/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'product_form_provider.dart';

class ProductFormDialog extends StatelessWidget {
  const ProductFormDialog({super.key, this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(product),
      child: _ProductFormDialogContent(product: product),
    );
  }
}

class _ProductFormDialogContent extends StatelessWidget {
  const _ProductFormDialogContent({required this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, ProductFormProvider>(
      builder: (context, app, formProvider, _) {
        final isDesktop = ResponsiveUtils.isDesktop(context);

        return ShadDialog(
          title: Text(product == null ? 'Add New Product' : 'Edit Product'),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final dialogWidth = isDesktop
                  ? 600.0
                  : constraints.maxWidth * 0.9;

              return SizedBox(
                width: dialogWidth,
                child: SingleChildScrollView(
                  child: ShadForm(
                    key: formProvider.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ProductNameField(),
                        const SizedBox(height: 16),
                        _BarcodeField(),
                        const SizedBox(height: 16),
                        _CategoryAndSupplierFields(
                          categories: app.categories,
                          suppliers: app.suppliers,
                        ),
                        const SizedBox(height: 16),
                        _PriceQuantityFields(),
                        const SizedBox(height: 16),
                        _ExpiryDateField(),
                        const SizedBox(height: 24),
                        _FormActions(product: product),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ProductNameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductFormProvider>(
      builder: (context, formProvider, _) {
        return ShadInputFormField(
          id: 'name',
          label: const Text('Product Name *'),
          controller: formProvider.nameController,
          placeholder: const Text('Enter product name'),
          validator: (value) {
            if (value.isEmpty) {
              return 'Product name is required';
            }
            return null;
          },
        );
      },
    );
  }
}

class _BarcodeField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductFormProvider>(
      builder: (context, formProvider, _) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ShadInputFormField(
                id: 'barcode',
                label: const Text('Barcode *'),
                controller: formProvider.barcodeController,
                placeholder: const Text('Scan or enter barcode'),
                trailing: IconButton(
                  icon: const Icon(LucideIcons.scan),
                  onPressed: () => _showBarcodeScanner(context, formProvider),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Barcode is required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
          ],
        );
      },
    );
  }

  void _showBarcodeScanner(
    BuildContext context,
    ProductFormProvider formProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => const _BarcodeScannerDialog(),
    ).then((barcode) {
      if (barcode != null) {
        formProvider.updateBarcode(barcode);
      }
    });
  }
}

class _BarcodeScannerDialog extends StatelessWidget {
  const _BarcodeScannerDialog();

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: const Text('Scan Barcode'),
      child: SizedBox(
        width: 300,
        height: 300,
        child: MobileScanner(
          onDetect: (capture) {
            final barcodes = capture.barcodes;
            if (barcodes.isNotEmpty) {
              final barcode = barcodes.first.rawValue ?? '';
              Navigator.of(context).pop(barcode);
            }
          },
        ),
      ),
    );
  }
}

class _CategoryAndSupplierFields extends StatelessWidget {
  const _CategoryAndSupplierFields({
    required this.categories,
    required this.suppliers,
  });

  final List<dynamic> categories;
  final List<dynamic> suppliers;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return Consumer<ProductFormProvider>(
      builder: (context, formProvider, _) {
        return Flex(
          direction: isDesktop ? Axis.horizontal : Axis.vertical,
          spacing: 16,
          children: [
            Flexible(
              key: UniqueKey(),
              flex: isDesktop ? 1 : 0,
              child: _CategoryDropdown(
                categories: categories,
                selectedCategoryId: formProvider.selectedCategoryId,
                onChanged: formProvider.updateSelectedCategory,
              ),
            ),
            Flexible(
              key: UniqueKey(),
              flex: isDesktop ? 1 : 0,
              child: _SupplierDropdown(
                suppliers: suppliers,
                selectedSupplierId: formProvider.selectedSupplierId,
                onChanged: formProvider.updateSelectedSupplier,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.categories,
    required this.selectedCategoryId,
    required this.onChanged,
  });

  final List<dynamic> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category *', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        ShadSelect<String>(
          placeholder: const Text('Select category'),
          minWidth: double.infinity,
          initialValue: selectedCategoryId,
          options: categories
              .map(
                (category) =>
                    ShadOption(value: category.id, child: Text(category.name)),
              )
              .toList(),
          selectedOptionBuilder: (context, value) =>
              Text(categories.firstWhere((c) => c.id == value).name),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _SupplierDropdown extends StatelessWidget {
  const _SupplierDropdown({
    required this.suppliers,
    required this.selectedSupplierId,
    required this.onChanged,
  });

  final List<dynamic> suppliers;
  final String? selectedSupplierId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Supplier *', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        ShadSelect<String>(
          minWidth: double.infinity,
          placeholder: const Text('Select supplier'),
          initialValue: selectedSupplierId,
          options: suppliers
              .map(
                (supplier) =>
                    ShadOption(value: supplier.id, child: Text(supplier.name)),
              )
              .toList(),
          selectedOptionBuilder: (context, value) =>
              Text(suppliers.firstWhere((s) => s.id == value).name),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _PriceQuantityFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return Consumer<ProductFormProvider>(
      builder: (context, formProvider, _) {
        return Flex(
          direction: isDesktop ? Axis.horizontal : Axis.vertical,
          spacing: 12,
          children: [
            Flexible(
              key: UniqueKey(),
              flex: isDesktop ? 1 : 0,
              child: ShadInputFormField(
                id: 'price',
                label: const Text('Price (\$)'),
                controller: formProvider.priceController,
                placeholder: const Text('0.00'),
                keyboardType: TextInputType.number,
              ),
            ),
            Flexible(
              key: UniqueKey(),
              flex: isDesktop ? 1 : 0,
              child: ShadInputFormField(
                id: 'quantity',
                label: const Text('Quantity'),
                controller: formProvider.quantityController,
                placeholder: const Text('0'),
                keyboardType: TextInputType.number,
              ),
            ),
            Flexible(
              key: UniqueKey(),
              flex: isDesktop ? 1 : 0,
              child: ShadInputFormField(
                id: 'minStock',
                label: const Text('Min Stock'),
                controller: formProvider.reorderThresholdController,
                placeholder: const Text('0'),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ExpiryDateField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductFormProvider>(
      builder: (context, formProvider, _) {
        return ShadInputFormField(
          id: 'expiry',
          label: const Text('Expiry Date'),
          controller: formProvider.expiryController,
          placeholder: const Text('YYYY-MM-DD'),
          keyboardType: TextInputType.datetime,
          onPressed: () => _showDatePicker(context, formProvider),
        );
      },
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    ProductFormProvider formProvider,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: formProvider.getInitialExpiryDate(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (date != null) {
      formProvider.updateExpiryDate(date);
    }
  }
}

class _FormActions extends StatelessWidget {
  const _FormActions({required this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductFormProvider>(
      builder: (context, formProvider, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ShadButton.outline(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 12),
            ShadButton(
              onPressed: formProvider.isLoading
                  ? null
                  : () => _saveProduct(context, formProvider),
              child: formProvider.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(product == null ? 'Add Product' : 'Update Product'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveProduct(
    BuildContext context,
    ProductFormProvider formProvider,
  ) async {
    if (!formProvider.validateForm()) {
      return;
    }

    if (!formProvider.validateSelections()) {
      _showErrorToast(context, 'Please select category and supplier');
      return;
    }

    try {
      // final product = formProvider.createProduct();

      // Uncomment and implement based on your AppProvider methods
      // if (this.product == null) {
      //   await context.read<AppProvider>().addProduct(product);
      // } else {
      //   await context.read<AppProvider>().updateProduct(product);
      // }

      if (context.mounted) {
        Navigator.of(context).pop();
        _showSuccessToast(
          context,
          product == null
              ? 'Product added successfully'
              : 'Product updated successfully',
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorToast(context, 'Failed to save product: $e');
      }
    }
  }

  void _showErrorToast(BuildContext context, String message) {
    ShadToaster.of(context).show(
      ShadToast.destructive(
        title: const Text('Error'),
        description: Text(message),
      ),
    );
  }

  void _showSuccessToast(BuildContext context, String message) {
    ShadToaster.of(
      context,
    ).show(ShadToast(title: const Text('Success'), description: Text(message)));
  }
}
