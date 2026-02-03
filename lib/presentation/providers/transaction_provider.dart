import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/datasources/transaction_local_datasource.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/get_all_transactions.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/update_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_balance.dart';
import '../../domain/usecases/get_total_income.dart';
import '../../domain/usecases/get_total_expense.dart';
import '../notifiers/transaction_notifier.dart';
import '../state/transaction_state.dart';

// Database provider - will be overridden in main.dart
final databaseProvider = Provider<Database>((ref) {
  throw UnimplementedError('Database must be initialized in main.dart');
});

// Data source provider
final transactionLocalDataSourceProvider =
    Provider<TransactionLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return TransactionLocalDataSourceImpl(database);
});

// Repository provider
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final dataSource = ref.watch(transactionLocalDataSourceProvider);
  return TransactionRepositoryImpl(dataSource);
});

// Use case providers
final getAllTransactionsProvider = Provider<GetAllTransactions>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return GetAllTransactions(repository);
});

final addTransactionProvider = Provider<AddTransaction>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return AddTransaction(repository);
});

final updateTransactionProvider = Provider<UpdateTransaction>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return UpdateTransaction(repository);
});

final deleteTransactionProvider = Provider<DeleteTransaction>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return DeleteTransaction(repository);
});

final getBalanceProvider = Provider<GetBalance>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return GetBalance(repository);
});

final getTotalIncomeProvider = Provider<GetTotalIncome>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return GetTotalIncome(repository);
});

final getTotalExpenseProvider = Provider<GetTotalExpense>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return GetTotalExpense(repository);
});

// State notifier provider
final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  return TransactionNotifier(
    getAllTransactions: ref.watch(getAllTransactionsProvider),
    addTransaction: ref.watch(addTransactionProvider),
    updateTransaction: ref.watch(updateTransactionProvider),
    deleteTransaction: ref.watch(deleteTransactionProvider),
    getBalance: ref.watch(getBalanceProvider),
    getTotalIncome: ref.watch(getTotalIncomeProvider),
    getTotalExpense: ref.watch(getTotalExpenseProvider),
  );
});
