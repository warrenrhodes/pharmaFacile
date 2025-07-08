import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sale_model.dart';
import '../utils/pdf_generator.dart';

final reportProvider = Provider<ReportProvider>((ref) => ReportProvider());

class ReportProvider {
  /// Generate a sales report PDF
  Future<Uint8List> generateSalesReport(String title, List<Sale> sales,
      {DateTime? startDate, DateTime? endDate}) async {
    return PdfGenerator.generateSalesReport(title, sales,
        startDate: startDate, endDate: endDate);
  }
}
