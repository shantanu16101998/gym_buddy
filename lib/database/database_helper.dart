import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Singleton pattern for database initialization
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If the database is not initialized, initialize it
    _database = await _initializeDB();
    return _database!;
  }

  Future<Database> _initializeDB() async {
    final dbPath = join(await getDatabasesPath(), 'user_subscription.db');
    return openDatabase(
      dbPath,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE user(id TEXT PRIMARY KEY, name TEXT, startDate TEXT, endDate TEXT, expiringDays INTEGER, expiredDays INTEGER, profilePic TEXT, contact TEXT, experience TEXT)',
        );
      },
      version: 1,
    );
  }
}
