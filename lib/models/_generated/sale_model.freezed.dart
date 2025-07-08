// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../sale_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Sale {

 String get id; List<SaleItem> get salesItems; double get totalPriceInUTC; DateTime get createdAt; String get updatedBy; String get cashier;
/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleCopyWith<Sale> get copyWith => _$SaleCopyWithImpl<Sale>(this as Sale, _$identity);

  /// Serializes this Sale to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sale&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.salesItems, salesItems)&&(identical(other.totalPriceInUTC, totalPriceInUTC) || other.totalPriceInUTC == totalPriceInUTC)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.cashier, cashier) || other.cashier == cashier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(salesItems),totalPriceInUTC,createdAt,updatedBy,cashier);

@override
String toString() {
  return 'Sale(id: $id, salesItems: $salesItems, totalPriceInUTC: $totalPriceInUTC, createdAt: $createdAt, updatedBy: $updatedBy, cashier: $cashier)';
}


}

/// @nodoc
abstract mixin class $SaleCopyWith<$Res>  {
  factory $SaleCopyWith(Sale value, $Res Function(Sale) _then) = _$SaleCopyWithImpl;
@useResult
$Res call({
 String id, List<SaleItem> salesItems, double totalPriceInUTC, DateTime createdAt, String updatedBy, String cashier
});




}
/// @nodoc
class _$SaleCopyWithImpl<$Res>
    implements $SaleCopyWith<$Res> {
  _$SaleCopyWithImpl(this._self, this._then);

  final Sale _self;
  final $Res Function(Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? salesItems = null,Object? totalPriceInUTC = null,Object? createdAt = null,Object? updatedBy = null,Object? cashier = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,salesItems: null == salesItems ? _self.salesItems : salesItems // ignore: cast_nullable_to_non_nullable
as List<SaleItem>,totalPriceInUTC: null == totalPriceInUTC ? _self.totalPriceInUTC : totalPriceInUTC // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,cashier: null == cashier ? _self.cashier : cashier // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Sale implements Sale {
  const _Sale({required this.id, required final  List<SaleItem> salesItems, required this.totalPriceInUTC, required this.createdAt, required this.updatedBy, required this.cashier}): _salesItems = salesItems;
  factory _Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);

@override final  String id;
 final  List<SaleItem> _salesItems;
@override List<SaleItem> get salesItems {
  if (_salesItems is EqualUnmodifiableListView) return _salesItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_salesItems);
}

@override final  double totalPriceInUTC;
@override final  DateTime createdAt;
@override final  String updatedBy;
@override final  String cashier;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleCopyWith<_Sale> get copyWith => __$SaleCopyWithImpl<_Sale>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sale&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._salesItems, _salesItems)&&(identical(other.totalPriceInUTC, totalPriceInUTC) || other.totalPriceInUTC == totalPriceInUTC)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.cashier, cashier) || other.cashier == cashier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_salesItems),totalPriceInUTC,createdAt,updatedBy,cashier);

@override
String toString() {
  return 'Sale(id: $id, salesItems: $salesItems, totalPriceInUTC: $totalPriceInUTC, createdAt: $createdAt, updatedBy: $updatedBy, cashier: $cashier)';
}


}

/// @nodoc
abstract mixin class _$SaleCopyWith<$Res> implements $SaleCopyWith<$Res> {
  factory _$SaleCopyWith(_Sale value, $Res Function(_Sale) _then) = __$SaleCopyWithImpl;
@override @useResult
$Res call({
 String id, List<SaleItem> salesItems, double totalPriceInUTC, DateTime createdAt, String updatedBy, String cashier
});




}
/// @nodoc
class __$SaleCopyWithImpl<$Res>
    implements _$SaleCopyWith<$Res> {
  __$SaleCopyWithImpl(this._self, this._then);

  final _Sale _self;
  final $Res Function(_Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? salesItems = null,Object? totalPriceInUTC = null,Object? createdAt = null,Object? updatedBy = null,Object? cashier = null,}) {
  return _then(_Sale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,salesItems: null == salesItems ? _self._salesItems : salesItems // ignore: cast_nullable_to_non_nullable
as List<SaleItem>,totalPriceInUTC: null == totalPriceInUTC ? _self.totalPriceInUTC : totalPriceInUTC // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,cashier: null == cashier ? _self.cashier : cashier // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
