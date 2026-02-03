import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/services/notification_service.dart';
import '../../data/datasources/spending_limit_local_datasource.dart';
import '../../data/repositories/spending_limit_repository_impl.dart';
import '../../domain/usecases/get_spending_limits.dart';
import '../../domain/usecases/set_spending_limit.dart';
import 'spending_limit_notifier.dart';
import 'spending_limit_state.dart';
import 'transaction_provider.dart';

// Database provider (already exists in transaction_provider.dart)
// We'll reuse it

// Datasource provider
final spendingLimitDataSourceProvider =
    Provider<SpendingLimitLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return SpendingLimitLocalDataSource(database);
});

// Repository provider
final spendingLimitRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(spendingLimitDataSourceProvider);
  return SpendingLimitRepositoryImpl(dataSource);
});

// Use cases providers
final getSpendingLimitsProvider = Provider((ref) {
  final repository = ref.watch(spendingLimitRepositoryProvider);
  return GetSpendingLimits(repository);
});

final setSpendingLimitProvider = Provider((ref) {
  final repository = ref.watch(spendingLimitRepositoryProvider);
  return SetSpendingLimit(repository);
});

// Notification service provider
final notificationServiceProvider = Provider((ref) {
  return NotificationService();
});

// Main state notifier provider
final spendingLimitNotifierProvider =
    StateNotifierProvider<SpendingLimitNotifier, SpendingLimitState>((ref) {
  final getSpendingLimits = ref.watch(getSpendingLimitsProvider);
  final setSpendingLimit = ref.watch(setSpendingLimitProvider);
  final notificationService = ref.watch(notificationServiceProvider);

  return SpendingLimitNotifier(
    getSpendingLimits: getSpendingLimits,
    setSpendingLimit: setSpendingLimit,
    notificationService: notificationService,
  );
});
