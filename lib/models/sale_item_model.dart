import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/sale_item_model.freezed.dart';
part '_generated/sale_item_model.g.dart';

@freezed
abstract class SaleItem with _$SaleItem {
  const factory SaleItem({
    required String productId,
    required String productName,
    required int quantity,
    required double unitPrice,
    required double total,
  }) = _SaleItem;

  factory SaleItem.fromJson(Map<String, dynamic> json) =>
      _$SaleItemFromJson(json);
}
