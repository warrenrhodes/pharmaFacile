// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; String get name; String get barcode; String get categoryId; double get price; int get quantity; DateTime get expiryDate; String get supplierId; int get reorderThreshold; String? get batchNumber; String? get manufacturer; DateTime get createdAtInUtc; DateTime get updatedAtInUtc;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.reorderThreshold, reorderThreshold) || other.reorderThreshold == reorderThreshold)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.createdAtInUtc, createdAtInUtc) || other.createdAtInUtc == createdAtInUtc)&&(identical(other.updatedAtInUtc, updatedAtInUtc) || other.updatedAtInUtc == updatedAtInUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,barcode,categoryId,price,quantity,expiryDate,supplierId,reorderThreshold,batchNumber,manufacturer,createdAtInUtc,updatedAtInUtc);

@override
String toString() {
  return 'Product(id: $id, name: $name, barcode: $barcode, categoryId: $categoryId, price: $price, quantity: $quantity, expiryDate: $expiryDate, supplierId: $supplierId, reorderThreshold: $reorderThreshold, batchNumber: $batchNumber, manufacturer: $manufacturer, createdAtInUtc: $createdAtInUtc, updatedAtInUtc: $updatedAtInUtc)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, String barcode, String categoryId, double price, int quantity, DateTime expiryDate, String supplierId, int reorderThreshold, String? batchNumber, String? manufacturer, DateTime createdAtInUtc, DateTime updatedAtInUtc
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? barcode = null,Object? categoryId = null,Object? price = null,Object? quantity = null,Object? expiryDate = null,Object? supplierId = null,Object? reorderThreshold = null,Object? batchNumber = freezed,Object? manufacturer = freezed,Object? createdAtInUtc = null,Object? updatedAtInUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,expiryDate: null == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,reorderThreshold: null == reorderThreshold ? _self.reorderThreshold : reorderThreshold // ignore: cast_nullable_to_non_nullable
as int,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,createdAtInUtc: null == createdAtInUtc ? _self.createdAtInUtc : createdAtInUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtInUtc: null == updatedAtInUtc ? _self.updatedAtInUtc : updatedAtInUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.name, required this.barcode, required this.categoryId, required this.price, required this.quantity, required this.expiryDate, required this.supplierId, required this.reorderThreshold, this.batchNumber, this.manufacturer, required this.createdAtInUtc, required this.updatedAtInUtc});
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String name;
@override final  String barcode;
@override final  String categoryId;
@override final  double price;
@override final  int quantity;
@override final  DateTime expiryDate;
@override final  String supplierId;
@override final  int reorderThreshold;
@override final  String? batchNumber;
@override final  String? manufacturer;
@override final  DateTime createdAtInUtc;
@override final  DateTime updatedAtInUtc;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.reorderThreshold, reorderThreshold) || other.reorderThreshold == reorderThreshold)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.createdAtInUtc, createdAtInUtc) || other.createdAtInUtc == createdAtInUtc)&&(identical(other.updatedAtInUtc, updatedAtInUtc) || other.updatedAtInUtc == updatedAtInUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,barcode,categoryId,price,quantity,expiryDate,supplierId,reorderThreshold,batchNumber,manufacturer,createdAtInUtc,updatedAtInUtc);

@override
String toString() {
  return 'Product(id: $id, name: $name, barcode: $barcode, categoryId: $categoryId, price: $price, quantity: $quantity, expiryDate: $expiryDate, supplierId: $supplierId, reorderThreshold: $reorderThreshold, batchNumber: $batchNumber, manufacturer: $manufacturer, createdAtInUtc: $createdAtInUtc, updatedAtInUtc: $updatedAtInUtc)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String barcode, String categoryId, double price, int quantity, DateTime expiryDate, String supplierId, int reorderThreshold, String? batchNumber, String? manufacturer, DateTime createdAtInUtc, DateTime updatedAtInUtc
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? barcode = null,Object? categoryId = null,Object? price = null,Object? quantity = null,Object? expiryDate = null,Object? supplierId = null,Object? reorderThreshold = null,Object? batchNumber = freezed,Object? manufacturer = freezed,Object? createdAtInUtc = null,Object? updatedAtInUtc = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,expiryDate: null == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,reorderThreshold: null == reorderThreshold ? _self.reorderThreshold : reorderThreshold // ignore: cast_nullable_to_non_nullable
as int,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,createdAtInUtc: null == createdAtInUtc ? _self.createdAtInUtc : createdAtInUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtInUtc: null == updatedAtInUtc ? _self.updatedAtInUtc : updatedAtInUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
