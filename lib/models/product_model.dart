import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/product_model.freezed.dart';
part '_generated/product_model.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String category,
    required double purchasePrice,
    required double sellingPrice,
    required int stock,
    required DateTime createdAt,
    required int minStock,
    DateTime? updatedAt,
    String? description,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
