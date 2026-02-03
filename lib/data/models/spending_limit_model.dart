import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/spending_limit.dart';

part 'spending_limit_model.freezed.dart';
part 'spending_limit_model.g.dart';

@freezed
class SpendingLimitModel with _$SpendingLimitModel {
  const SpendingLimitModel._();

  const factory SpendingLimitModel({
    int? id,
    required String period,
    required double amount,
    required bool isEnabled,
    required String createdAt,
  }) = _SpendingLimitModel;

  factory SpendingLimitModel.fromJson(Map<String, dynamic> json) =>
      _$SpendingLimitModelFromJson(json);

  // Convert from Entity
  factory SpendingLimitModel.fromEntity(SpendingLimit limit) {
    return SpendingLimitModel(
      id: limit.id,
      period: limit.period.name,
      amount: limit.amount,
      isEnabled: limit.isEnabled,
      createdAt: limit.createdAt.toIso8601String(),
    );
  }

  // Convert to Entity
  SpendingLimit toEntity() {
    return SpendingLimit(
      id: id,
      period: LimitPeriod.fromJson(period),
      amount: amount,
      isEnabled: isEnabled,
      createdAt: DateTime.parse(createdAt),
    );
  }

  // Convert from Database Map
  factory SpendingLimitModel.fromMap(Map<String, dynamic> map) {
    return SpendingLimitModel(
      id: map['id'] as int?,
      period: map['period'] as String,
      amount: map['amount'] as double,
      isEnabled: (map['is_enabled'] as int) == 1,
      createdAt: map['created_at'] as String,
    );
  }

  // Convert to Database Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'period': period,
      'amount': amount,
      'is_enabled': isEnabled ? 1 : 0,
      'created_at': createdAt,
    };
  }
}
