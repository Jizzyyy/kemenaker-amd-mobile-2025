import '../models/transaction_model.dart';
import '../providers/database_provider.dart';

class TransactionRepository {
  final DatabaseProvider _databaseProvider = DatabaseProvider.instance;

  Future<int> addTransaction(TransactionModel transaction) async {
    return await _databaseProvider.create(transaction);
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    return await _databaseProvider.readAll();
  }

  Future<List<TransactionModel>> getTransactionsByType(String type) async {
    return await _databaseProvider.readByType(type);
  }

  Future<TransactionModel?> getTransactionById(int id) async {
    return await _databaseProvider.read(id);
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    return await _databaseProvider.update(transaction);
  }

  Future<int> deleteTransaction(int id) async {
    return await _databaseProvider.delete(id);
  }

  // Calculate total income
  Future<double> getTotalIncome() async {
    final transactions = await getTransactionsByType('income');
    return transactions.fold<double>(0.0, (sum, transaction) => sum + transaction.amount);
  }

  // Calculate total expense
  Future<double> getTotalExpense() async {
    final transactions = await getTransactionsByType('expense');
    return transactions.fold<double>(0.0, (sum, transaction) => sum + transaction.amount);
  }

  // Get balance
  Future<double> getBalance() async {
    final income = await getTotalIncome();
    final expense = await getTotalExpense();
    return income - expense;
  }
}
