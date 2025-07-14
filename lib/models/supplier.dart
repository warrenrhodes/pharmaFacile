import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/supplier.freezed.dart';
part '_generated/supplier.g.dart';

@freezed
abstract class Supplier with _$Supplier {
  const factory Supplier({
    required String id,
    required String name,
    required String phone,
    required bool isActive,
    String? notes,
    String? email,
    String? address,
    required DateTime createdAtInUtc,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);
}
