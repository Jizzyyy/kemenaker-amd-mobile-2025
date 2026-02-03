import 'package:sqflite/sqflite.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel?> getTransactionById(int id);
  Future<int> addTransaction(TransactionModel transaction);
  Future<int> updateTransaction(TransactionModel transaction);
  Future<int> deleteTransaction(int id);
  Future<List<TransactionModel>> getTransactionsByType(String type);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Database database;

  TransactionLocalDataSourceImpl(this.database);

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      const orderBy = 'date DESC';
      final result = await database.query('transactions', orderBy: orderBy);
      return result.map((json) => TransactionModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to get transactions: $e');
    }
  }

  @override
  Future<TransactionModel?> getTransactionById(int id) async {
    try {
      final maps = await database.query(
        'transactions',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return TransactionModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get transaction by id: $e');
    }
  }

  @override
  Future<int> addTransaction(TransactionModel transaction) async {
    try {
      return await database.insert('transactions', transaction.toMap());
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<int> updateTransaction(TransactionModel transaction) async {
    try {
      return await database.update(
        'transactions',
        transaction.toMap(),
        where: 'id = ?',
        whereArgs: [transaction.id],
      );
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  @override
  Future<int> deleteTransaction(int id) async {
    try {
      return await database.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByType(String type) async {
    try {
      final result = await database.query(
        'transactions',
        where: 'type = ?',
        whereArgs: [type],
        orderBy: 'date DESC',
      );
      return result.map((json) => TransactionModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to get transactions by type: $e');
    }
  }
}
