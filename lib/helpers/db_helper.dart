import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'task_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE boards(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE lists(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            boardId INTEGER,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            boardId INTEGER,
            listId INTEGER,
            title TEXT,
            description TEXT,
            dueDate TEXT,
            priority TEXT,
            assignedTo TEXT,
            isDone INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  // User operations
  Future<int> registerUser(String username, String password) async {
    final db = await database;
    return await db
        .insert('users', {'username': username, 'password': password});
  }

  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Board operations
  Future<int> createBoard(String name) async {
    final db = await database;
    return await db.insert('boards', {'name': name});
  }

  Future<List<Map<String, dynamic>>> getBoards() async {
    final db = await database;
    return await db.query('boards');
  }

  // List operations
  Future<int> createList(int boardId, String name) async {
    final db = await database;
    return await db.insert('lists', {'boardId': boardId, 'name': name});
  }

  Future<List<Map<String, dynamic>>> getLists(int boardId) async {
    final db = await database;
    return await db.query('lists', where: 'boardId = ?', whereArgs: [boardId]);
  }

  Future<void> createTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle conflicts properly
    );
  }

  Future<List<Task>> getTasks(int listId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('tasks', where: 'listId = ?', whereArgs: [listId]);
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
