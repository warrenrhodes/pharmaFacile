import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacie_stock/utils/fake.dart';

import '../models/sale_model.dart';
import '../services/sale_service.dart';

final saleServiceProvider = Provider<SaleService>((ref) => SaleService());

final dailySalesStreamProvider = StreamProvider.family<List<Sale>, DateTime>((
  ref,
  date,
) {
  final service = ref.watch(saleServiceProvider);
  return service.getDailySalesStream(date);
});

final salesByRangeStreamProvider =
    StreamProvider.family<List<Sale>, Map<String, DateTime>>((ref, range) {
      final service = ref.watch(saleServiceProvider);
      return service.getSalesByDateRange(range['start']!, range['end']!);
    });

class SaleListNotifier extends StateNotifier<AsyncValue<List<Sale>>> {
  final SaleService _service;
  SaleListNotifier(this._service) : super(const AsyncValue.loading()) {
    state = AsyncValue.data(initialSales);
  }

  Future<void> recordSale(Sale sale) async {
    await _service.recordSale(sale);
  }
}

final saleListProvider =
    StateNotifierProvider<SaleListNotifier, AsyncValue<List<Sale>>>((ref) {
      final service = ref.watch(saleServiceProvider);
      return SaleListNotifier(service);
    });
