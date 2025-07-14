import 'package:flutter/material.dart';
import 'package:pharmacie_stock/config/internationalizations/internationalization.dart';
import 'package:pharmacie_stock/models/supplier.dart';
import 'package:pharmacie_stock/providers/app_provider.dart';
import 'package:pharmacie_stock/utils/app_colors.dart';
import 'package:pharmacie_stock/utils/formatters.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'components/suppliers_form_dialogue.dart';

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = context.watch<Internationalization>();

    return Consumer<AppProvider>(
      builder: (context, inventory, _) {
        final statsCard = [
          _buildStatCard(
            'Total Suppliers',
            inventory.suppliers.length.toString(),
            'Active suppliers',
            LucideIcons.building400,
            Colors.blue,
          ),
          _buildStatCard(
            'Total Products',
            inventory.products.length.toString(),
            'From all suppliers',
            LucideIcons.package400,
            Colors.green,
          ),
          _buildStatCard(
            'Avg Products',
            inventory.suppliers.isNotEmpty
                ? (inventory.products.length / inventory.suppliers.length)
                      .round()
                      .toString()
                : '0',
            'Per supplier',
            LucideIcons.trendingUp400,
            Colors.purple,
          ),
          _buildStatCard(
            'Total Value',
            Formatters.formatCurrency(
              inventory.totalInventoryValue,
              intl.locale,
            ),
            'All inventory',
            LucideIcons.wallet400,
            Colors.orange,
          ),
        ];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Supplier Management',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage your supplier relationships',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  ShadButton(
                    onPressed: () => _showSupplierDialog(context, null),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.plus400, size: 16),
                        SizedBox(width: 8),
                        Text('Add Supplier'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  int columns = (constraints.maxWidth / 250).floor();
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 150,
                    ),
                    itemCount: statsCard.length,
                    itemBuilder: (context, index) {
                      final statCart = statsCard[index];
                      return statCart;
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              // Suppliers Table
              ShadCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.building400, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Suppliers (${inventory.suppliers.length})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Manage your supplier relationships and contacts',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dataRowMinHeight: 80,
                          dataRowMaxHeight: 80,
                          columns: const [
                            DataColumn(label: Text('Supplier')),
                            DataColumn(label: Text('Contact Info')),
                            DataColumn(label: Text('Products')),
                            DataColumn(label: Text('Total Value')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Notes')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: inventory.suppliers.map((supplier) {
                            final supplierProducts = inventory.products
                                .where((p) => p.supplierId == supplier.id)
                                .toList();
                            final totalValue = supplierProducts.fold(
                              0.0,
                              (sum, p) => sum + (p.price * p.quantity),
                            );

                            return DataRow(
                              cells: [
                                DataCell(
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        supplier.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (supplier.address?.isNotEmpty == true)
                                        Row(
                                          children: [
                                            const Icon(
                                              LucideIcons.mapPin400,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                supplier.address ?? '',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (supplier.phone.isNotEmpty)
                                        Text(
                                          supplier.phone,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),

                                      if (supplier.email?.isNotEmpty == true)
                                        Row(
                                          children: [
                                            const Icon(
                                              LucideIcons.mail400,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              supplier.email ?? '',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${supplierProducts.length} products',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    Formatters.formatCurrency(
                                      totalValue,
                                      intl.locale,
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: supplier.isActive
                                          ? AppColors.dartGreen.withValues(
                                              alpha: 0.1,
                                            )
                                          : AppColors.red.withValues(
                                              alpha: 0.1,
                                            ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      supplier.isActive
                                          ? intl.active
                                          : intl.inactive,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: supplier.isActive
                                            ? AppColors.dartGreen
                                            : AppColors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(supplier.notes ?? '/')),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          LucideIcons.squarePen400,
                                          size: 16,
                                        ),
                                        onPressed: () => _showSupplierDialog(
                                          context,
                                          supplier,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          LucideIcons.trash2400,
                                          size: 16,
                                        ),
                                        onPressed: () => _showDeleteDialog(
                                          context,
                                          supplier,
                                          supplierProducts.length,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, size: 20, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showSupplierDialog(BuildContext context, Supplier? supplier) {
    showDialog(
      context: context,
      builder: (context) => SupplierFormDialog(supplier: supplier),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    Supplier supplier,
    int productCount,
  ) {
    if (productCount > 0) {
      ShadToaster.of(context).show(
        const ShadToast.destructive(
          description: Text(
            "You can't delete a supplier who contains a product",
          ),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Delete Supplier'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to delete "${supplier.name}"? This action cannot be undone.',
            ),
            if (productCount > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.triangleAlert400,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Warning: This supplier has $productCount products. Please reassign or remove products first.',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShadButton.outline(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ShadButton(
                  onPressed: productCount > 0
                      ? null
                      : () async {
                          try {
                            // await context
                            //     .read<AppProvider>()
                            //     .deleteSupplier(supplier.id);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ShadToaster.of(context).show(
                                const ShadToast(
                                  title: Text('Success'),
                                  description: Text(
                                    'Supplier deleted successfully',
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ShadToaster.of(context).show(
                                ShadToast.destructive(
                                  title: const Text('Error'),
                                  description: Text(
                                    'Failed to delete supplier: $e',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
