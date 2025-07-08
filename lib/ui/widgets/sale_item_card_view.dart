import 'package:flutter/material.dart';
import 'package:pharmacie_stock/models/sale_item_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SaleItemCardView extends StatelessWidget {
  final SaleItem sale;
  const SaleItemCardView({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: ListTile(
        title: Text(sale.productName),
        subtitle: Text(
          'Qté: ${sale.quantity} | PU: ${sale.unitPrice} F | Total: ${sale.total} F',
        ),
      ),
    );
  }
}
