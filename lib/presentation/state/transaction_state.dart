import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transaction.dart';

part 'transaction_state.freezed.dart';

@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState({
    @Default([]) List<Transaction> transactions,
    @Default([]) List<Transaction> filteredTransactions,
    @Default(0.0) double totalIncome,
    @Default(0.0) double totalExpense,
    @Default(0.0) double balance,
    @Default(false) bool isLoading,
    @Default('all') String selectedFilter,
    String? errorMessage,
  }) = _TransactionState;
}
