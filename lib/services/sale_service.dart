import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacie_stock/utils/fake.dart';

import '../models/sale_model.dart';
import 'firestore_service.dart';

class SaleService {
  final FirestoreService _firestore = FirestoreService();
  final String _collection = 'sales';

  /// Record a new sale
  Future<void> recordSale(Sale sale) async {
    await _firestore.setDocument('$_collection/${sale.id}', sale.toJson());
  }

  /// Get a stream of daily sales
  Stream<List<Sale>> getDailySalesStream(DateTime date) {
    final start = Timestamp.fromDate(DateTime(date.year, date.month, date.day));
    final end = Timestamp.fromDate(
      DateTime(date.year, date.month, date.day, 23, 59, 59),
    );
    return Stream.value(initialSales);
    // FirebaseFirestore.instance
    //     .collection(_collection)
    //     .where('saleDate', isGreaterThanOrEqualTo: start)
    //     .where('saleDate', isLessThanOrEqualTo: end)
    //     .snapshots()
    //     .map(
    //       (snapshot) =>
    //           snapshot.docs.map((doc) => Sale.fromJson(doc.data())).toList(),
    //     );
  }

  /// Get sales by date range
  Stream<List<Sale>> getSalesByDateRange(DateTime startDate, DateTime endDate) {
    final start = Timestamp.fromDate(startDate);
    final end = Timestamp.fromDate(endDate);
    return Stream.value(initialSales);
    // FirebaseFirestore.instance
    //     .collection(_collection)
    //     .where('saleDate', isGreaterThanOrEqualTo: start)
    //     .where('saleDate', isLessThanOrEqualTo: end)
    //     .snapshots()
    //     .map((snapshot) =>
    //         snapshot.docs.map((doc) => Sale.fromJson(doc.data())).toList());
  }
}
