import 'package:coursework1_mad/model/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class authDatabaseController {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initializeDatabase();
    return _database;
  }

  Future<Database> _initializeDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = join(directory.path, 'auth_database.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE Auth (id INTEGER PRIMARY KEY AUTOINCREMENT,email TEXT, password TEXT)',
    );
  }

  Future<User?> addUser(User user) async {
    final db = await database;
    int userId = await db!.insert('Auth', user.toMap());
    return User(id: userId, email: user.email, password: user.password);
  }

  Future<User?> login(String email, String password) async {
    final db = await database;
    final queryResults = await db!.query('Auth',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (queryResults.isNotEmpty) {
      return User.fromMap(queryResults.first);
    }
    return null;
  }
}