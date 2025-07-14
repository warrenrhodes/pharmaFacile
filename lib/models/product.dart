import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/product.freezed.dart';
part '_generated/product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String barcode,
    required String categoryId,
    required double price,
    required int quantity,
    required DateTime expiryDate,
    required String supplierId,
    required int reorderThreshold,
    String? batchNumber,
    String? manufacturer,
    required DateTime createdAtInUtc,
    required DateTime updatedAtInUtc,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
