import 'package:sqflite/sqflite.dart';
import '../models/spending_limit_model.dart';

class SpendingLimitLocalDataSource {
  final Database database;

  SpendingLimitLocalDataSource(this.database);

  Future<List<SpendingLimitModel>> getAllLimits() async {
    final maps = await database.query('spending_limits');
    return maps.map((map) => SpendingLimitModel.fromMap(map)).toList();
  }

  Future<SpendingLimitModel?> getLimitByPeriod(String period) async {
    final maps = await database.query(
      'spending_limits',
      where: 'period = ?',
      whereArgs: [period],
    );

    if (maps.isEmpty) return null;
    return SpendingLimitModel.fromMap(maps.first);
  }

  Future<void> insertLimit(SpendingLimitModel limit) async {
    await database.insert(
      'spending_limits',
      limit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateLimit(SpendingLimitModel limit) async {
    await database.update(
      'spending_limits',
      limit.toMap(),
      where: 'id = ?',
      whereArgs: [limit.id],
    );
  }

  Future<void> deleteLimit(int id) async {
    await database.delete(
      'spending_limits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleLimit(int id, bool isEnabled) async {
    await database.update(
      'spending_limits',
      {'is_enabled': isEnabled ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
