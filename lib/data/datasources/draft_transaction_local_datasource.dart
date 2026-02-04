import 'package:sqflite/sqflite.dart';
import '../models/draft_transaction_model.dart';

abstract class DraftTransactionLocalDataSource {
  Future<List<DraftTransactionModel>> getAllDrafts();
  Future<DraftTransactionModel?> getDraftById(int id);
  Future<int> addDraft(DraftTransactionModel draft);
  Future<int> deleteDraft(int id);
  Future<int> deleteAllDrafts();
  Future<bool> existsByNotificationKey(String notificationKey);
}

class DraftTransactionLocalDataSourceImpl
    implements DraftTransactionLocalDataSource {
  final Database database;

  DraftTransactionLocalDataSourceImpl(this.database);

  @override
  Future<List<DraftTransactionModel>> getAllDrafts() async {
    try {
      final result = await database.query(
        'draft_transactions',
        orderBy: 'created_at DESC',
      );
      return result.map(DraftTransactionModel.fromMap).toList();
    } catch (e) {
      throw Exception('Failed to get draft transactions: $e');
    }
  }

  @override
  Future<DraftTransactionModel?> getDraftById(int id) async {
    try {
      final result = await database.query(
        'draft_transactions',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (result.isEmpty) return null;
      return DraftTransactionModel.fromMap(result.first);
    } catch (e) {
      throw Exception('Failed to get draft transaction by id: $e');
    }
  }

  @override
  Future<int> addDraft(DraftTransactionModel draft) async {
    try {
      return await database.insert('draft_transactions', draft.toMap());
    } catch (e) {
      throw Exception('Failed to add draft transaction: $e');
    }
  }

  @override
  Future<int> deleteDraft(int id) async {
    try {
      return await database.delete(
        'draft_transactions',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete draft transaction: $e');
    }
  }

  @override
  Future<int> deleteAllDrafts() async {
    try {
      return await database.delete('draft_transactions');
    } catch (e) {
      throw Exception('Failed to delete all draft transactions: $e');
    }
  }

  @override
  Future<bool> existsByNotificationKey(String notificationKey) async {
    try {
      final result = await database.query(
        'draft_transactions',
        columns: ['id'],
        where: 'notification_key = ?',
        whereArgs: [notificationKey],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check notification key: $e');
    }
  }
}
