import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../config/app_constants.dart';
import '../../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock = product.stock <= kLowStockThreshold;
    return ShadCard(
      child: ListTile(
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Achat: ${product.purchasePrice} F | Vente: ${product.sellingPrice} F'),
            Row(
              children: [
                const Text('Stock: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '${product.stock}',
                  style:
                      TextStyle(color: isLowStock ? Colors.red : Colors.black),
                ),
                if (isLowStock)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: ShadBadge(child: Text('Stock bas')),
                  ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
