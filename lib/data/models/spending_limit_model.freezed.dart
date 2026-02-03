// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spending_limit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpendingLimitModel _$SpendingLimitModelFromJson(Map<String, dynamic> json) {
  return _SpendingLimitModel.fromJson(json);
}

/// @nodoc
mixin _$SpendingLimitModel {
  int? get id => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SpendingLimitModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpendingLimitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpendingLimitModelCopyWith<SpendingLimitModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpendingLimitModelCopyWith<$Res> {
  factory $SpendingLimitModelCopyWith(
          SpendingLimitModel value, $Res Function(SpendingLimitModel) then) =
      _$SpendingLimitModelCopyWithImpl<$Res, SpendingLimitModel>;
  @useResult
  $Res call(
      {int? id,
      String period,
      double amount,
      bool isEnabled,
      String createdAt});
}

/// @nodoc
class _$SpendingLimitModelCopyWithImpl<$Res, $Val extends SpendingLimitModel>
    implements $SpendingLimitModelCopyWith<$Res> {
  _$SpendingLimitModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpendingLimitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? period = null,
    Object? amount = null,
    Object? isEnabled = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpendingLimitModelImplCopyWith<$Res>
    implements $SpendingLimitModelCopyWith<$Res> {
  factory _$$SpendingLimitModelImplCopyWith(_$SpendingLimitModelImpl value,
          $Res Function(_$SpendingLimitModelImpl) then) =
      __$$SpendingLimitModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String period,
      double amount,
      bool isEnabled,
      String createdAt});
}

/// @nodoc
class __$$SpendingLimitModelImplCopyWithImpl<$Res>
    extends _$SpendingLimitModelCopyWithImpl<$Res, _$SpendingLimitModelImpl>
    implements _$$SpendingLimitModelImplCopyWith<$Res> {
  __$$SpendingLimitModelImplCopyWithImpl(_$SpendingLimitModelImpl _value,
      $Res Function(_$SpendingLimitModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpendingLimitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? period = null,
    Object? amount = null,
    Object? isEnabled = null,
    Object? createdAt = null,
  }) {
    return _then(_$SpendingLimitModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpendingLimitModelImpl extends _SpendingLimitModel {
  const _$SpendingLimitModelImpl(
      {this.id,
      required this.period,
      required this.amount,
      required this.isEnabled,
      required this.createdAt})
      : super._();

  factory _$SpendingLimitModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpendingLimitModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String period;
  @override
  final double amount;
  @override
  final bool isEnabled;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'SpendingLimitModel(id: $id, period: $period, amount: $amount, isEnabled: $isEnabled, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpendingLimitModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, period, amount, isEnabled, createdAt);

  /// Create a copy of SpendingLimitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpendingLimitModelImplCopyWith<_$SpendingLimitModelImpl> get copyWith =>
      __$$SpendingLimitModelImplCopyWithImpl<_$SpendingLimitModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpendingLimitModelImplToJson(
      this,
    );
  }
}

abstract class _SpendingLimitModel extends SpendingLimitModel {
  const factory _SpendingLimitModel(
      {final int? id,
      required final String period,
      required final double amount,
      required final bool isEnabled,
      required final String createdAt}) = _$SpendingLimitModelImpl;
  const _SpendingLimitModel._() : super._();

  factory _SpendingLimitModel.fromJson(Map<String, dynamic> json) =
      _$SpendingLimitModelImpl.fromJson;

  @override
  int? get id;
  @override
  String get period;
  @override
  double get amount;
  @override
  bool get isEnabled;
  @override
  String get createdAt;

  /// Create a copy of SpendingLimitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpendingLimitModelImplCopyWith<_$SpendingLimitModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
