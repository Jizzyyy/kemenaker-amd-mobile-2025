import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/transaction_state.dart';
import '../../domain/usecases/get_all_transactions.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/update_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_balance.dart';
import '../../domain/usecases/get_total_income.dart';
import '../../domain/usecases/get_total_expense.dart';
import '../../domain/entities/transaction.dart';

class TransactionNotifier extends StateNotifier<TransactionState> {
  final GetAllTransactions getAllTransactions;
  final AddTransaction addTransaction;
  final UpdateTransaction updateTransaction;
  final DeleteTransaction deleteTransaction;
  final GetBalance getBalance;
  final GetTotalIncome getTotalIncome;
  final GetTotalExpense getTotalExpense;
  final Future<void> Function()? onTransactionChanged;

  TransactionNotifier({
    required this.getAllTransactions,
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
    required this.getBalance,
    required this.getTotalIncome,
    required this.getTotalExpense,
    this.onTransactionChanged,
  }) : super(const TransactionState());

  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await getAllTransactions();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (transactions) {
        state = state.copyWith(
          isLoading: false,
          transactions: transactions,
          filteredTransactions:
              _applyFilter(transactions, state.selectedFilter),
        );
        _calculateTotals();
      },
    );
  }

  Future<void> _calculateTotals() async {
    final balanceResult = await getBalance();
    final incomeResult = await getTotalIncome();
    final expenseResult = await getTotalExpense();

    balanceResult.fold(
      (failure) {},
      (balance) => state = state.copyWith(balance: balance),
    );

    incomeResult.fold(
      (failure) {},
      (income) => state = state.copyWith(totalIncome: income),
    );

    expenseResult.fold(
      (failure) {},
      (expense) => state = state.copyWith(totalExpense: expense),
    );
  }

  void filterTransactions(String filter) {
    state = state.copyWith(
      selectedFilter: filter,
      filteredTransactions: _applyFilter(state.transactions, filter),
    );
  }

  List<Transaction> _applyFilter(
      List<Transaction> transactions, String filter) {
    if (filter == 'all') {
      return transactions;
    } else if (filter == 'income') {
      return transactions
          .where((t) => t.type == TransactionType.income)
          .toList();
    } else if (filter == 'expense') {
      return transactions
          .where((t) => t.type == TransactionType.expense)
          .toList();
    }
    return transactions;
  }

  Future<bool> addNewTransaction(Transaction transaction) async {
    final result = await addTransaction(transaction);

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (id) async {
        await loadTransactions();
        // Check spending limits and trigger notifications if needed
        if (onTransactionChanged != null) {
          await onTransactionChanged!();
        }
        return true;
      },
    );
  }

  Future<bool> updateExistingTransaction(Transaction transaction) async {
    final result = await updateTransaction(transaction);

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (rowsAffected) async {
        await loadTransactions();
        // Check spending limits and trigger notifications if needed
        if (onTransactionChanged != null) {
          await onTransactionChanged!();
        }
        return true;
      },
    );
  }

  Future<bool> removeTransaction(int id) async {
    final result = await deleteTransaction(id);

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (rowsAffected) {
        loadTransactions();
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
