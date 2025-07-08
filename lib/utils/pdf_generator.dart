import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

import '../models/sale_model.dart';

class PdfGenerator {
  /// Generate a sales report PDF from a list of sales
  static Future<Uint8List> generateSalesReport(
    String title,
    List<Sale> sales, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            if (startDate != null && endDate != null)
              pw.Text(
                'Du ${startDate.toLocal()} au ${endDate.toLocal()}',
                style: const pw.TextStyle(fontSize: 14),
              ),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['Produit', 'Qté', 'PU', 'Total'],
              data: sales
                  .map((e) => e.salesItems)
                  .expand((e) => e)
                  .map(
                    (s) => [
                      s.productName,
                      s.quantity.toString(),
                      s.unitPrice.toStringAsFixed(2),
                      s.total.toStringAsFixed(2),
                    ],
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
    return pdf.save();
  }
}
