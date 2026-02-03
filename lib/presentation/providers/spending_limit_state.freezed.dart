// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spending_limit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SpendingLimitState {
  List<SpendingLimit> get limits => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  Map<LimitPeriod, double> get currentSpending =>
      throw _privateConstructorUsedError;

  /// Create a copy of SpendingLimitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpendingLimitStateCopyWith<SpendingLimitState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpendingLimitStateCopyWith<$Res> {
  factory $SpendingLimitStateCopyWith(
          SpendingLimitState value, $Res Function(SpendingLimitState) then) =
      _$SpendingLimitStateCopyWithImpl<$Res, SpendingLimitState>;
  @useResult
  $Res call(
      {List<SpendingLimit> limits,
      bool isLoading,
      String? errorMessage,
      Map<LimitPeriod, double> currentSpending});
}

/// @nodoc
class _$SpendingLimitStateCopyWithImpl<$Res, $Val extends SpendingLimitState>
    implements $SpendingLimitStateCopyWith<$Res> {
  _$SpendingLimitStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpendingLimitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? limits = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? currentSpending = null,
  }) {
    return _then(_value.copyWith(
      limits: null == limits
          ? _value.limits
          : limits // ignore: cast_nullable_to_non_nullable
              as List<SpendingLimit>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      currentSpending: null == currentSpending
          ? _value.currentSpending
          : currentSpending // ignore: cast_nullable_to_non_nullable
              as Map<LimitPeriod, double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpendingLimitStateImplCopyWith<$Res>
    implements $SpendingLimitStateCopyWith<$Res> {
  factory _$$SpendingLimitStateImplCopyWith(_$SpendingLimitStateImpl value,
          $Res Function(_$SpendingLimitStateImpl) then) =
      __$$SpendingLimitStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SpendingLimit> limits,
      bool isLoading,
      String? errorMessage,
      Map<LimitPeriod, double> currentSpending});
}

/// @nodoc
class __$$SpendingLimitStateImplCopyWithImpl<$Res>
    extends _$SpendingLimitStateCopyWithImpl<$Res, _$SpendingLimitStateImpl>
    implements _$$SpendingLimitStateImplCopyWith<$Res> {
  __$$SpendingLimitStateImplCopyWithImpl(_$SpendingLimitStateImpl _value,
      $Res Function(_$SpendingLimitStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpendingLimitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? limits = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? currentSpending = null,
  }) {
    return _then(_$SpendingLimitStateImpl(
      limits: null == limits
          ? _value._limits
          : limits // ignore: cast_nullable_to_non_nullable
              as List<SpendingLimit>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      currentSpending: null == currentSpending
          ? _value._currentSpending
          : currentSpending // ignore: cast_nullable_to_non_nullable
              as Map<LimitPeriod, double>,
    ));
  }
}

/// @nodoc

class _$SpendingLimitStateImpl implements _SpendingLimitState {
  const _$SpendingLimitStateImpl(
      {final List<SpendingLimit> limits = const [],
      this.isLoading = false,
      this.errorMessage,
      final Map<LimitPeriod, double> currentSpending = const {}})
      : _limits = limits,
        _currentSpending = currentSpending;

  final List<SpendingLimit> _limits;
  @override
  @JsonKey()
  List<SpendingLimit> get limits {
    if (_limits is EqualUnmodifiableListView) return _limits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_limits);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  final Map<LimitPeriod, double> _currentSpending;
  @override
  @JsonKey()
  Map<LimitPeriod, double> get currentSpending {
    if (_currentSpending is EqualUnmodifiableMapView) return _currentSpending;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_currentSpending);
  }

  @override
  String toString() {
    return 'SpendingLimitState(limits: $limits, isLoading: $isLoading, errorMessage: $errorMessage, currentSpending: $currentSpending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpendingLimitStateImpl &&
            const DeepCollectionEquality().equals(other._limits, _limits) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._currentSpending, _currentSpending));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_limits),
      isLoading,
      errorMessage,
      const DeepCollectionEquality().hash(_currentSpending));

  /// Create a copy of SpendingLimitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpendingLimitStateImplCopyWith<_$SpendingLimitStateImpl> get copyWith =>
      __$$SpendingLimitStateImplCopyWithImpl<_$SpendingLimitStateImpl>(
          this, _$identity);
}

abstract class _SpendingLimitState implements SpendingLimitState {
  const factory _SpendingLimitState(
          {final List<SpendingLimit> limits,
          final bool isLoading,
          final String? errorMessage,
          final Map<LimitPeriod, double> currentSpending}) =
      _$SpendingLimitStateImpl;

  @override
  List<SpendingLimit> get limits;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  Map<LimitPeriod, double> get currentSpending;

  /// Create a copy of SpendingLimitState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpendingLimitStateImplCopyWith<_$SpendingLimitStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
