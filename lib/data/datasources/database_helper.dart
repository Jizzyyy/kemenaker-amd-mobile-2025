import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> initDatabase() async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'transactions.db');

    _database = await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );

    return _database!;
  }

  static Future<void> _upgradeDB(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE transactions ADD COLUMN imagePath TEXT');
    }
    if (oldVersion < 3) {
      // Create spending_limits table
      await db.execute('''
        CREATE TABLE spending_limits (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          period TEXT NOT NULL,
          amount REAL NOT NULL,
          is_enabled INTEGER NOT NULL DEFAULT 1,
          created_at TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE draft_transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          amount REAL NOT NULL,
          type TEXT NOT NULL,
          category TEXT NOT NULL,
          date TEXT NOT NULL,
          description TEXT,
          imagePath TEXT,
          source_app TEXT NOT NULL,
          raw_text TEXT NOT NULL,
          notification_key TEXT,
          created_at TEXT NOT NULL
        )
      ''');
    }
  }

  static Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        title $textType,
        amount $realType,
        type $textType,
        category $textType,
        date $textType,
        description TEXT,
        imagePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE spending_limits (
        id $idType,
        period $textType,
        amount $realType,
        is_enabled INTEGER NOT NULL DEFAULT 1,
        created_at $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE draft_transactions (
        id $idType,
        title $textType,
        amount $realType,
        type $textType,
        category $textType,
        date $textType,
        description TEXT,
        imagePath TEXT,
        source_app $textType,
        raw_text $textType,
        notification_key TEXT,
        created_at $textType
      )
    ''');
  }

  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
