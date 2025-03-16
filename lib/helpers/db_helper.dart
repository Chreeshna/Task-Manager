import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static late Database _db;

  // Open or create the database
  static Future<void> initDB() async {
    String path = join(await getDatabasesPath(), 'task_manager.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      // Create table for users
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL,
          password TEXT NOT NULL
        )
      ''');
    });
  }

  // Register a new user
  static Future<bool> registerUser(String username, String password) async {
    try {
      await _db.insert(
        'users',
        {'username': username, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print("Error during user registration: $e");
      return false;
    }
  }

  // Check if user exists
  static Future<bool> checkUserExists(String username) async {
    final result = await _db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  // For testing purposes: get all users
  static Future<List<Map<String, dynamic>>> getUsers() async {
    return await _db.query('users');
  }
}
