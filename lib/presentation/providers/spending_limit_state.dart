import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/spending_limit.dart';

part 'spending_limit_state.freezed.dart';

@freezed
class SpendingLimitState with _$SpendingLimitState {
  const factory SpendingLimitState({
    @Default([]) List<SpendingLimit> limits,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default({}) Map<LimitPeriod, double> currentSpending,
  }) = _SpendingLimitState;
}
