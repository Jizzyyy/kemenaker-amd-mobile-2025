import 'package:aplikasi_pencatatan_keuangan/domain/entities/transaction.dart';

class SpendingCalculator {
  /// Calculate total expenses for today
  static double calculateDailySpending(List<Transaction> transactions) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return transactions
        .where((t) =>
            t.type == TransactionType.expense && _isSameDay(t.date, today))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Calculate total expenses for current week (Monday - Sunday)
  static double calculateWeeklySpending(List<Transaction> transactions) {
    final now = DateTime.now();
    final weekStart = _getWeekStart(now);
    final weekEnd = weekStart.add(const Duration(days: 7));

    return transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            t.date.isBefore(weekEnd))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Calculate total expenses for current month
  static double calculateMonthlySpending(List<Transaction> transactions) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    return transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.date.isAfter(monthStart.subtract(const Duration(days: 1))) &&
            t.date.isBefore(monthEnd.add(const Duration(days: 1))))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Get start of current week (Monday)
  static DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: weekday - 1));
  }

  /// Check if two dates are the same day
  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Calculate percentage of limit used
  static double calculatePercentage(double spending, double limit) {
    if (limit == 0) return 0;
    return (spending / limit) * 100;
  }

  /// Get period display name
  static String getPeriodName(String period) {
    switch (period) {
      case 'daily':
        return 'Hari Ini';
      case 'weekly':
        return 'Minggu Ini';
      case 'monthly':
        return 'Bulan Ini';
      default:
        return period;
    }
  }
}
