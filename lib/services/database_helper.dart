import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../user_details.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT,
          password TEXT,
          userType TEXT
        )
      ''');
    });
  }

  // Function to fetch users
  Future<List<UserDetails>> users() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return UserDetails(
        email: maps[i]['email'],
        password: maps[i]['password'],
        userType: maps[i]['userType'],
      );
    });
  }
}
