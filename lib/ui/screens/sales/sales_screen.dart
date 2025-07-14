import 'package:flutter/material.dart';
import 'package:pharmacie_stock/config/internationalizations/internationalization.dart';
import 'package:pharmacie_stock/models/category.dart';
import 'package:pharmacie_stock/models/product.dart';
import 'package:pharmacie_stock/models/transaction.dart';
import 'package:pharmacie_stock/models/user.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/providers/auth_provider.dart';
import 'package:pharmacie_stock/providers/cart_provider.dart';
import 'package:pharmacie_stock/utils/app_colors.dart';
import 'package:pharmacie_stock/utils/app_constants.dart';
import 'package:pharmacie_stock/utils/formatters.dart';
import 'package:pharmacie_stock/utils/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'sales_provider.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SalesProvider(),
      child: const _SalesScreenContent(),
    );
  }
}

class _SalesScreenContent extends StatelessWidget {
  const _SalesScreenContent();

  @override
  Widget build(BuildContext context) {
    return Consumer4<AppProvider, CartProvider, AuthProvider, SalesProvider>(
      builder: (context, appProvider, cartProvider, auth, sales, _) {
        final canSell = auth.hasPermission(PermissionType.sales);
        final isDesktop = ResponsiveUtils.isDesktop(context);

        void showCheckoutDialog(BuildContext context) {
          showDialog(
            context: context,
            builder: (context) => _CheckoutDialog(sales),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 24 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SalesHeader(
                  cartItemCount: cartProvider.cart.length,
                  cartTotal: cartProvider.cartTotal,
                  canSell: canSell,
                  onCheckout: cartProvider.cart.isEmpty
                      ? null
                      : () => showCheckoutDialog(context),
                ),
                const SizedBox(height: 32),
                Flex(
                  direction: !isDesktop ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Flexible(
                      flex: !isDesktop ? 0 : 2,
                      child: _ProductSelectionSection(
                        sales: sales,
                        canSell: canSell,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      flex: !isDesktop ? 0 : 1,
                      child: _ShoppingCartSection(),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                _RecentSalesSection(transactions: appProvider.transactions),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SalesHeader extends StatelessWidget {
  const _SalesHeader({
    required this.cartItemCount,
    required this.cartTotal,
    required this.canSell,
    required this.onCheckout,
  });

  final int cartItemCount;
  final double cartTotal;
  final bool canSell;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final theme = ShadTheme.of(context);
    final intl = context.watch<Internationalization>();

    return Flex(
      direction: isMobile ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Flexible(
          flex: isMobile ? 0 : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sales Management', style: theme.textTheme.h4),
              const SizedBox(height: 4),
              Text(
                'Process sales and manage transactions',
                style: theme.textTheme.muted,
              ),
            ],
          ),
        ),
        Flexible(
          flex: isMobile ? 0 : 1,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cobalt.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                ),
                child: Text(
                  'Cart: $cartItemCount items',
                  style: theme.textTheme.p.copyWith(color: AppColors.cobalt),
                ),
              ),
              const SizedBox(width: 12),
              if (canSell)
                Flexible(
                  child: ShadButton(
                    onPressed: onCheckout,
                    leading: const Icon(LucideIcons.shoppingCart, size: 16),
                    child: Flexible(
                      child: Text(
                        'Checkout (${Formatters.formatCurrency(cartTotal, intl.locale)})',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductSelectionSection extends StatelessWidget {
  const _ProductSelectionSection({required this.sales, required this.canSell});

  final SalesProvider sales;
  final bool canSell;

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    List<Product> getFilteredProducts() {
      return appProvider.products
          .where((product) => product.quantity > 0)
          .where(
            (product) =>
                product.name.toLowerCase().contains(
                  sales.searchQuery.toLowerCase(),
                ) ||
                product.barcode.contains(sales.searchQuery),
          )
          .toList();
    }

    return Column(
      children: [
        _ProductSearchCard(
          searchQuery: sales.searchQuery,
          onSearchChanged: sales.updateSearchQuery,
        ),
        const SizedBox(height: 16),
        _ProductsGrid(
          products: getFilteredProducts(),
          categories: appProvider.categories,
          canSell: canSell,
        ),
      ],
    );
  }
}

class _ProductSearchCard extends StatelessWidget {
  const _ProductSearchCard({
    required this.searchQuery,
    required this.onSearchChanged,
  });

  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Search',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Search and add products to cart',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ShadInput(
              placeholder: const Text('Search by name or barcode...'),
              leading: const Icon(LucideIcons.search, size: 16),
              onChanged: onSearchChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  const _ProductsGrid({
    required this.products,
    required this.categories,
    required this.canSell,
  });

  final List<Product> products;
  final List<Category> categories;
  final bool canSell;

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return SizedBox(
      height: 400,
      child: LayoutBuilder(
        builder: (context, constraints) {
          int columns = (constraints.maxWidth / 300).floor();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 200,
            ),
            itemCount: products.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final product = products[index];
              final category = _findCategory(product.categoryId);
              return _ProductCard(
                product: product,
                category: category,
                canSell: canSell,
                onAddToCart: () => cartProvider.addToCart(product),
              );
            },
          );
        },
      ),
    );
  }

  Category _findCategory(String categoryId) {
    return categories.firstWhere((category) => category.id == categoryId);
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.category,
    required this.canSell,
    required this.onAddToCart,
  });

  final Product product;
  final Category category;
  final bool canSell;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final intl = context.watch<Internationalization>();
    return ShadCard(
      padding: const EdgeInsets.all(AppConstants.contentPadding),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.name,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Formatters.formatCurrency(product.price, intl.locale),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                ShadBadge(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    '${product.quantity} left',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (canSell)
              SizedBox(
                width: double.infinity,
                child: ShadButton(
                  size: ShadButtonSize.sm,
                  onPressed: onAddToCart,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.plus, size: 12),
                      SizedBox(width: 4),
                      Text('Add to Cart'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ShoppingCartSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shopping Cart',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${cartProvider.cart.length} items',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (cartProvider.cart.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Cart is empty',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Column(
                children: [
                  _CartItemsList(items: cartProvider.cart),
                  const Divider(),
                  _CartTotal(
                    total: cartProvider.cart.fold(
                      0.0,
                      (sum, item) => sum + item.total,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CartItemsList extends StatelessWidget {
  const _CartItemsList({required this.items});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _CartItemCard(item: item);
        },
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.product.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${Formatters.formatCurrency(item.product.price.toDouble(), context.watch<Internationalization>().locale)} each',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            _CartItemControls(item: item),
          ],
        ),
      ),
    );
  }
}

class _CartItemControls extends StatelessWidget {
  const _CartItemControls({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ShadButton.outline(
              size: ShadButtonSize.sm,
              onPressed: () => cartProvider.updateCartQuantity(
                item.product.id,
                item.quantity - 1,
              ),
              child: const Icon(LucideIcons.minus, size: 12),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.quantity.toString(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ShadButton.outline(
              size: ShadButtonSize.sm,
              onPressed: () => cartProvider.updateCartQuantity(
                item.product.id,
                item.quantity + 1,
              ),
              child: const Icon(LucideIcons.plus, size: 12),
            ),
          ],
        ),
        Text(
          Formatters.formatCurrency(
            item.total,
            context.watch<Internationalization>().locale,
          ),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

class _CartTotal extends StatelessWidget {
  const _CartTotal({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          Formatters.formatCurrency(
            total,
            context.watch<Internationalization>().locale,
          ),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

class _RecentSalesSection extends StatelessWidget {
  const _RecentSalesSection({required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Sales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Latest sales transactions',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _RecentSalesTable(transactions: transactions),
          ],
        ),
      ),
    );
  }
}

class _RecentSalesTable extends StatelessWidget {
  const _RecentSalesTable({required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final intl = Provider.of<Internationalization>(context);
    final salesTransactions = transactions
        .where((transaction) => transaction.type == TransactionType.sale)
        .take(10)
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Product')),
          DataColumn(label: Text('Quantity')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Total')),
          DataColumn(label: Text('Notes')),
        ],
        rows: salesTransactions.map((transaction) {
          final product = _findProduct(
            appProvider.products,
            transaction.productId,
          );
          return DataRow(
            cells: [
              DataCell(Text(DateFormat('MMM dd').format(transaction.date))),
              DataCell(Text(product.name)),
              DataCell(Text(transaction.quantity.toString())),
              DataCell(
                Text(
                  Formatters.formatCurrency(
                    transaction.price.toDouble(),
                    intl.locale,
                  ),
                ),
              ),
              DataCell(
                Text(
                  Formatters.formatCurrency(
                    transaction.total.toDouble(),
                    intl.locale,
                  ),
                ),
              ),
              DataCell(Text(transaction.notes ?? '-')),
            ],
          );
        }).toList(),
      ),
    );
  }

  Product _findProduct(List<Product> products, String productId) {
    return products.firstWhere(
      (product) => product.id == productId,
      orElse: () => Product(
        id: '',
        name: 'Unknown Product',
        barcode: '',
        categoryId: '',
        price: 0,
        quantity: 0,
        reorderThreshold: 0,
        expiryDate: DateTime.now(),
        supplierId: '',
        createdAtInUtc: DateTime.now(),
        updatedAtInUtc: DateTime.now(),
      ),
    );
  }
}

class _CheckoutDialog extends StatelessWidget {
  const _CheckoutDialog(this.salesProvider);
  final SalesProvider salesProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppProvider, CartProvider, AuthProvider>(
      builder: (context, appProvider, cartProvider, auth, _) {
        final subtotal = cartProvider.cartTotal;
        final discountAmount = subtotal * (salesProvider.discount / 100);
        final total = subtotal - discountAmount;

        return ShadDialog(
          title: const Text('Checkout'),
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Review and complete the sale'),
                const SizedBox(height: 20),
                _CheckoutCartItems(items: cartProvider.cart),
                const SizedBox(height: 16),
                _CheckoutDiscountInput(
                  discount: salesProvider.discount,
                  onDiscountChanged: salesProvider.updateDiscount,
                ),
                const SizedBox(height: 16),
                _CheckoutTotals(
                  subtotal: subtotal,
                  discount: salesProvider.discount,
                  discountAmount: discountAmount,
                  total: total,
                ),
                const SizedBox(height: 20),
                _CheckoutActions(
                  onCancel: () => Navigator.of(context).pop(),
                  onComplete: () => _completeSale(
                    context,
                    cartProvider,
                    appProvider,
                    salesProvider,
                    auth,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _completeSale(
    BuildContext context,
    CartProvider cartProvider,
    AppProvider appProvider,
    SalesProvider sales,
    AuthProvider auth,
  ) async {
    try {
      final user = auth.currentUser!;

      for (final item in cartProvider.cart) {
        final transaction = Transaction(
          id: '',
          type: TransactionType.sale,
          productId: item.product.id,
          userId: user.id,
          quantity: item.quantity,
          price: item.product.price,
          date: DateTime.now(),
          notes: sales.discount > 0
              ? '${sales.discount.toStringAsFixed(1)}% discount applied'
              : 'Regular sale',
          total: item.total,
        );

        await appProvider.addTransaction(transaction);
      }

      cartProvider.clearCart();
      sales.resetDiscount();

      if (context.mounted) {
        Navigator.of(context).pop();
        ShadToaster.of(context).show(
          const ShadToast(
            title: Text('Sale Completed'),
            description: Text('Transaction completed successfully'),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Error'),
            description: Text('Failed to complete sale: $error'),
          ),
        );
      }
    }
  }
}

class _CheckoutCartItems extends StatelessWidget {
  const _CheckoutCartItems({required this.items});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              title: Text(item.product.name),
              subtitle: Text('\$${item.product.price.toStringAsFixed(2)} each'),
              trailing: Text(
                '${item.quantity} × \$${item.total.toStringAsFixed(2)}',
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CheckoutDiscountInput extends StatelessWidget {
  const _CheckoutDiscountInput({
    required this.discount,
    required this.onDiscountChanged,
  });

  final double discount;
  final ValueChanged<double> onDiscountChanged;

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      placeholder: const Text('Discount (%)'),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final parsedDiscount = double.tryParse(value) ?? 0.0;
        final clampedDiscount = parsedDiscount.clamp(0.0, 100.0);
        onDiscountChanged(clampedDiscount);
      },
    );
  }
}

class _CheckoutTotals extends StatelessWidget {
  const _CheckoutTotals({
    required this.subtotal,
    required this.discount,
    required this.discountAmount,
    required this.total,
  });

  final double subtotal;
  final double discount;
  final double discountAmount;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal:'),
              Text('\$${subtotal.toStringAsFixed(2)}'),
            ],
          ),
          if (discount > 0) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discount (${discount.toStringAsFixed(1)}%):'),
                Text(
                  '-\$${discountAmount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
          ],
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CheckoutActions extends StatelessWidget {
  const _CheckoutActions({required this.onCancel, required this.onComplete});

  final VoidCallback onCancel;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ShadButton.outline(onPressed: onCancel, child: const Text('Cancel')),
        const SizedBox(width: 12),
        ShadButton(
          onPressed: onComplete,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.receipt, size: 16),
              SizedBox(width: 8),
              Text('Complete Sale'),
            ],
          ),
        ),
      ],
    );
  }
}
