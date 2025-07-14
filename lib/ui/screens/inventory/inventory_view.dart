import 'package:flutter/material.dart';
import 'package:pharmacie_stock/config/internationalizations/internationalization.dart';
import 'package:pharmacie_stock/models/category.dart';
import 'package:pharmacie_stock/models/product.dart';
import 'package:pharmacie_stock/models/supplier.dart';
import 'package:pharmacie_stock/models/user.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/providers/auth_provider.dart';
import 'package:pharmacie_stock/utils/app_colors.dart';
import 'package:pharmacie_stock/utils/currency_formatter.dart';
import 'package:pharmacie_stock/utils/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'components/product/product_form_v2.dart';
import 'inventory_provider.dart';

class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InventoryProvider(),
      child: const _InventoryViewContent(),
    );
  }
}

class _InventoryViewContent extends StatelessWidget {
  const _InventoryViewContent();

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppProvider, AuthProvider, InventoryProvider>(
      builder: (context, app, auth, ui, _) {
        final canModify = auth.hasPermission(PermissionType.inventory);
        final filteredProducts = _getFilteredProducts(app.products, ui);

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = ResponsiveUtils.isDesktop(context);

            return SingleChildScrollView(
              padding: EdgeInsets.all(isDesktop ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InventoryHeader(canModify: canModify),
                  SizedBox(height: isDesktop ? 32 : 24),
                  _SearchAndFilterCard(categories: app.categories),
                  SizedBox(height: isDesktop ? 24 : 16),
                  _ProductsTable(
                    products: filteredProducts,
                    categories: app.categories,
                    suppliers: app.suppliers,
                    canModify: canModify,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Product> _getFilteredProducts(
    List<Product> products,
    InventoryProvider ui,
  ) {
    return products.where((product) {
      final matchesSearch =
          product.name.toLowerCase().contains(ui.searchQuery.toLowerCase()) ||
          product.barcode.contains(ui.searchQuery);
      final matchesCategory =
          ui.selectedCategory == 'all' ||
          product.categoryId == ui.selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }
}

class _InventoryHeader extends StatelessWidget {
  const _InventoryHeader({required this.canModify});

  final bool canModify;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final theme = ShadTheme.of(context);

    return Flex(
      direction: isDesktop ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: isDesktop
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Management', style: theme.textTheme.h4),
            const SizedBox(height: 4),
            Text(
              'Manage your pharmacy inventory',
              style: theme.textTheme.muted,
            ),
          ],
        ),
        if (!isDesktop) const SizedBox(height: 16),
        if (canModify)
          ShadButton(
            onPressed: () => _showProductDialog(context, null),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.plus, size: 16),
                SizedBox(width: 8),
                Text('Add Product'),
              ],
            ),
          ),
      ],
    );
  }

  void _showProductDialog(BuildContext context, Product? product) {
    showShadDialog(
      context: context,
      builder: (context) => ProductFormDialog(product: product),
    );
  }
}

class _SearchAndFilterCard extends StatelessWidget {
  const _SearchAndFilterCard({required this.categories});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search & Filter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Flexible(
                  key: UniqueKey(),
                  flex: isDesktop ? 3 : 0,
                  child: const _SearchInput(),
                ),
                Flexible(
                  key: UniqueKey(),
                  flex: isDesktop ? 1 : 0,
                  child: _CategoryFilter(categories: categories),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput();

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, ui, _) {
        return ShadInput(
          controller: ui.searchController,
          placeholder: const Text('Search by name or barcode...'),
          leading: const Icon(LucideIcons.search, size: 16),
          onChanged: ui.updateSearchQuery,
        );
      },
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.categories});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, ui, _) {
        return ShadSelect<String>(
          placeholder: const Text('All Categories'),
          options: [
            const ShadOption(value: 'all', child: Text('All Categories')),
            ...categories.map(
              (category) =>
                  ShadOption(value: category.id, child: Text(category.name)),
            ),
          ],
          selectedOptionBuilder: (context, value) => Text(
            value == 'all'
                ? 'All Categories'
                : categories.firstWhere((c) => c.id == value).name,
          ),
          onChanged: ui.updateSelectedCategory,
        );
      },
    );
  }
}

class _ProductsTable extends StatelessWidget {
  const _ProductsTable({
    required this.products,
    required this.categories,
    required this.suppliers,
    required this.canModify,
  });

  final List<Product> products;
  final List<Category> categories;
  final List<Supplier> suppliers;
  final bool canModify;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductsTableHeader(productCount: products.length),
            const SizedBox(height: 20),
            if (!isMobile)
              _ProductsDataTable(
                products: products,
                categories: categories,
                suppliers: suppliers,
                canModify: canModify,
              )
            else
              _ProductsCardList(
                products: products,
                categories: categories,
                suppliers: suppliers,
                canModify: canModify,
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductsTableHeader extends StatelessWidget {
  const _ProductsTableHeader({required this.productCount});

  final int productCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.package, size: 20),
            const SizedBox(width: 8),
            Text(
              'Products ($productCount)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Manage your product inventory',
          style: ShadTheme.of(context).textTheme.muted,
        ),
      ],
    );
  }
}

class _ProductsDataTable extends StatelessWidget {
  const _ProductsDataTable({
    required this.products,
    required this.categories,
    required this.suppliers,
    required this.canModify,
  });

  final List<Product> products;
  final List<Category> categories;
  final List<Supplier> suppliers;
  final bool canModify;

  @override
  Widget build(BuildContext context) {
    final intl = context.watch<Internationalization>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        horizontalMargin: 12,
        dataRowMaxHeight: 80,
        columns: const [
          DataColumn(label: Text('Product')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Stock')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Expiry')),
          DataColumn(label: Text('Actions')),
        ],
        rows: products.map((product) {
          final category = categories.firstWhere(
            (c) => c.id == product.categoryId,
          );
          final supplier = suppliers.firstWhere(
            (s) => s.id == product.supplierId,
          );

          return DataRow(
            cells: [
              DataCell(
                _ProductNameCell(product: product, supplierName: supplier.name),
              ),
              DataCell(_CategoryCell(categoryName: category.name)),
              DataCell(
                Text(
                  CurrencyFormatter.formatCurrency(product.price, intl.locale),
                  style: ShadTheme.of(context).textTheme.p,
                ),
              ),
              DataCell(_StockCell(product: product)),
              DataCell(_StatusCell(product: product)),
              DataCell(_ExpiryCell(product: product)),
              DataCell(_ActionsCell(product: product, canModify: canModify)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ProductsCardList extends StatelessWidget {
  const _ProductsCardList({
    required this.products,
    required this.categories,
    required this.suppliers,
    required this.canModify,
  });

  final List<Product> products;
  final List<Category> categories;
  final List<Supplier> suppliers;
  final bool canModify;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = products[index];
        final category = categories.firstWhere(
          (c) => c.id == product.categoryId,
        );
        final supplier = suppliers.firstWhere(
          (s) => s.id == product.supplierId,
        );

        return _ProductCard(
          product: product,
          category: category,
          supplier: supplier,
          canModify: canModify,
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.category,
    required this.supplier,
    required this.canModify,
  });

  final Product product;
  final Category category;
  final Supplier supplier;
  final bool canModify;

  @override
  Widget build(BuildContext context) {
    final intl = context.watch<Internationalization>();
    final theme = ShadTheme.of(context);

    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: theme.textTheme.large),
                      const SizedBox(height: 4),
                      Text(
                        '${product.barcode} • ${supplier.name}',
                        style: theme.textTheme.muted,
                      ),
                    ],
                  ),
                ),
                if (canModify)
                  _ActionsCell(product: product, canModify: canModify),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(intl.category, style: theme.textTheme.p),
                Text(category.name, style: theme.textTheme.muted),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(intl.price, style: theme.textTheme.p),
                Text(
                  CurrencyFormatter.formatCurrency(product.price, intl.locale),
                  style: theme.textTheme.muted,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(intl.stock, style: theme.textTheme.p),
                _InfoChip(
                  value: '${product.quantity} units',
                  color: AppColors.warningColor,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(intl.expired, style: theme.textTheme.p),
                _ExpiryCell(product: product),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(intl.supplier, style: theme.textTheme.p),
                Text(supplier.name, style: theme.textTheme.muted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.value, required this.color});

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ShadBadge(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      backgroundColor: color.withValues(alpha: .1),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProductNameCell extends StatelessWidget {
  const _ProductNameCell({required this.product, required this.supplierName});

  final Product product;
  final String supplierName;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(product.name, style: theme.textTheme.large),
        Text(
          '${product.barcode} • $supplierName',
          style: theme.textTheme.muted,
        ),
      ],
    );
  }
}

class _CategoryCell extends StatelessWidget {
  const _CategoryCell({required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return ShadBadge(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(categoryName),
    );
  }
}

class _StockCell extends StatelessWidget {
  const _StockCell({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${product.quantity} units', style: theme.textTheme.p),
        Text('Min: ${product.reorderThreshold}', style: theme.textTheme.muted),
      ],
    );
  }
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final inventoryProvider = context.watch<InventoryProvider>();
    ({String text, Color color}) getProductStatus(Product product) {
      if (product.quantity <= 0) {
        return (text: 'Out of Stock', color: AppColors.red);
      } else if (inventoryProvider.isLowStock(product)) {
        return (text: 'Low Stock', color: AppColors.warningColor);
      } else {
        return (text: 'In Stock', color: AppColors.dartGreen);
      }
    }

    final status = getProductStatus(product);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.text,
        style: theme.textTheme.muted.copyWith(
          color: status.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ExpiryCell extends StatelessWidget {
  const _ExpiryCell({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = context.watch<InventoryProvider>();
    final theme = ShadTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat('MMM dd, yyyy').format(product.expiryDate),
          style: theme.textTheme.muted,
        ),
        if (inventoryProvider.isExpiringSoon(product)) ...[
          const SizedBox(width: 4),
          const Icon(
            LucideIcons.triangleAlert,
            size: 12,
            color: AppColors.warningColor,
          ),
        ],
      ],
    );
  }
}

class _ActionsCell extends StatelessWidget {
  const _ActionsCell({required this.product, required this.canModify});

  final Product product;
  final bool canModify;

  @override
  Widget build(BuildContext context) {
    if (!canModify) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        IconButton(
          icon: const Icon(LucideIcons.squarePen400),
          onPressed: () => _showProductDialog(context, product),
        ),
        IconButton(
          icon: const Icon(LucideIcons.trash2400),
          onPressed: () => _showDeleteDialog(context, product),
        ),
      ],
    );
  }

  void _showProductDialog(BuildContext context, Product product) {
    showShadDialog(
      context: context,
      builder: (context) => ProductFormDialog(product: product),
    );
  }

  void _showDeleteDialog(BuildContext context, Product product) {
    showShadDialog(
      context: context,
      builder: (context) => _DeleteProductDialog(product: product),
    );
  }
}

class _DeleteProductDialog extends StatelessWidget {
  const _DeleteProductDialog({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: const Text('Delete Product'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Are you sure you want to delete "${product.name}"? This action cannot be undone.',
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShadButton.raw(
                variant: ShadButtonVariant.outline,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              ShadButton(
                onPressed: () => _deleteProduct(context),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct(BuildContext context) async {
    try {
      // await context.read<AppProvider>().deleteProduct(product.id);
      if (context.mounted) {
        Navigator.of(context).pop();
        ShadToaster.of(context).show(
          const ShadToast(
            title: Text('Success'),
            description: Text('Product deleted successfully'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Error'),
            description: Text('Failed to delete product: $e'),
          ),
        );
      }
    }
  }
}
