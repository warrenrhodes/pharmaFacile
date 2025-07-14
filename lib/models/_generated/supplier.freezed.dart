// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../supplier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Supplier {

 String get id; String get name; String get phone; bool get isActive; String? get notes; String? get email; String? get address; DateTime get createdAtInUtc;
/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupplierCopyWith<Supplier> get copyWith => _$SupplierCopyWithImpl<Supplier>(this as Supplier, _$identity);

  /// Serializes this Supplier to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Supplier&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.createdAtInUtc, createdAtInUtc) || other.createdAtInUtc == createdAtInUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,isActive,notes,email,address,createdAtInUtc);

@override
String toString() {
  return 'Supplier(id: $id, name: $name, phone: $phone, isActive: $isActive, notes: $notes, email: $email, address: $address, createdAtInUtc: $createdAtInUtc)';
}


}

/// @nodoc
abstract mixin class $SupplierCopyWith<$Res>  {
  factory $SupplierCopyWith(Supplier value, $Res Function(Supplier) _then) = _$SupplierCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phone, bool isActive, String? notes, String? email, String? address, DateTime createdAtInUtc
});




}
/// @nodoc
class _$SupplierCopyWithImpl<$Res>
    implements $SupplierCopyWith<$Res> {
  _$SupplierCopyWithImpl(this._self, this._then);

  final Supplier _self;
  final $Res Function(Supplier) _then;

/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? isActive = null,Object? notes = freezed,Object? email = freezed,Object? address = freezed,Object? createdAtInUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,createdAtInUtc: null == createdAtInUtc ? _self.createdAtInUtc : createdAtInUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Supplier implements Supplier {
  const _Supplier({required this.id, required this.name, required this.phone, required this.isActive, this.notes, this.email, this.address, required this.createdAtInUtc});
  factory _Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);

@override final  String id;
@override final  String name;
@override final  String phone;
@override final  bool isActive;
@override final  String? notes;
@override final  String? email;
@override final  String? address;
@override final  DateTime createdAtInUtc;

/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupplierCopyWith<_Supplier> get copyWith => __$SupplierCopyWithImpl<_Supplier>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupplierToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Supplier&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.createdAtInUtc, createdAtInUtc) || other.createdAtInUtc == createdAtInUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,isActive,notes,email,address,createdAtInUtc);

@override
String toString() {
  return 'Supplier(id: $id, name: $name, phone: $phone, isActive: $isActive, notes: $notes, email: $email, address: $address, createdAtInUtc: $createdAtInUtc)';
}


}

/// @nodoc
abstract mixin class _$SupplierCopyWith<$Res> implements $SupplierCopyWith<$Res> {
  factory _$SupplierCopyWith(_Supplier value, $Res Function(_Supplier) _then) = __$SupplierCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phone, bool isActive, String? notes, String? email, String? address, DateTime createdAtInUtc
});




}
/// @nodoc
class __$SupplierCopyWithImpl<$Res>
    implements _$SupplierCopyWith<$Res> {
  __$SupplierCopyWithImpl(this._self, this._then);

  final _Supplier _self;
  final $Res Function(_Supplier) _then;

/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? isActive = null,Object? notes = freezed,Object? email = freezed,Object? address = freezed,Object? createdAtInUtc = null,}) {
  return _then(_Supplier(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,createdAtInUtc: null == createdAtInUtc ? _self.createdAtInUtc : createdAtInUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
