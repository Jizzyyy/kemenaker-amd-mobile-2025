import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/notification_service.dart';
import '../../core/utils/spending_calculator.dart';
import '../../domain/entities/spending_limit.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_spending_limits.dart';
import '../../domain/usecases/set_spending_limit.dart';
import 'spending_limit_state.dart';

class SpendingLimitNotifier extends StateNotifier<SpendingLimitState> {
  final GetSpendingLimits getSpendingLimits;
  final SetSpendingLimit setSpendingLimit;
  final NotificationService notificationService;

  SpendingLimitNotifier({
    required this.getSpendingLimits,
    required this.setSpendingLimit,
    required this.notificationService,
  }) : super(const SpendingLimitState());

  Future<void> loadLimits() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await getSpendingLimits();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (limits) {
        state = state.copyWith(
          isLoading: false,
          limits: limits,
        );
      },
    );
  }

  Future<bool> saveLimit(SpendingLimit limit) async {
    final result = await setSpendingLimit(limit);

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (_) {
        loadLimits();
        return true;
      },
    );
  }

  void updateCurrentSpending(List<Transaction> transactions) {
    final dailySpending =
        SpendingCalculator.calculateDailySpending(transactions);
    final weeklySpending =
        SpendingCalculator.calculateWeeklySpending(transactions);
    final monthlySpending =
        SpendingCalculator.calculateMonthlySpending(transactions);

    state = state.copyWith(
      currentSpending: {
        LimitPeriod.daily: dailySpending,
        LimitPeriod.weekly: weeklySpending,
        LimitPeriod.monthly: monthlySpending,
      },
    );
  }

  Future<void> checkLimitsAndNotify(List<Transaction> transactions) async {
    updateCurrentSpending(transactions);

    for (final limit in state.limits) {
      if (!limit.isEnabled) continue;

      final currentSpending = state.currentSpending[limit.period] ?? 0;
      final percentage = SpendingCalculator.calculatePercentage(
        currentSpending,
        limit.amount,
      );

      // Show alert if exceeded 100%
      if (percentage >= 100) {
        await notificationService.showAlertNotification(
          period: limit.period.name,
          current: currentSpending,
          limit: limit.amount,
        );
      }
      // Show warning if reached 80%
      else if (percentage >= 80) {
        await notificationService.showWarningNotification(
          period: limit.period.name,
          percentage: percentage,
          current: currentSpending,
          limit: limit.amount,
        );
      }
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
