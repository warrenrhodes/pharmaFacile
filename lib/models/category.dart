import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/category.freezed.dart';
part '_generated/category.g.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? description,
    required DateTime createdAtInUtc,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
