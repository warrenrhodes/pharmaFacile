import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/transaction.freezed.dart';
part '_generated/transaction.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required TransactionType type,
    required String productId,
    required String userId,
    required int quantity,
    required num price,
    required num total,
    required DateTime date,
    String? notes,
    String? receiptNumber,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

enum TransactionType {
  stockIn('IN'),
  sale('OUT');

  const TransactionType(this.value);
  final String value;

  String get name => value;
}
