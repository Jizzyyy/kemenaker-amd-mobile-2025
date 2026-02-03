// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spending_limit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpendingLimitModelImpl _$$SpendingLimitModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SpendingLimitModelImpl(
      id: (json['id'] as num?)?.toInt(),
      period: json['period'] as String,
      amount: (json['amount'] as num).toDouble(),
      isEnabled: json['isEnabled'] as bool,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$SpendingLimitModelImplToJson(
        _$SpendingLimitModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'period': instance.period,
      'amount': instance.amount,
      'isEnabled': instance.isEnabled,
      'createdAt': instance.createdAt,
    };
