import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacie_stock/models/sale_item_model.dart';

part '_generated/sale_model.freezed.dart';
part '_generated/sale_model.g.dart';

@freezed
abstract class Sale with _$Sale {
  const factory Sale({
    required String id,
    required List<SaleItem> salesItems,
    required double totalPriceInUTC,
    required DateTime createdAt,
    required String updatedBy,
    required String cashier,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}
