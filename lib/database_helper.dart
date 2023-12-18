import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'book.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'books.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        author TEXT,
        genre TEXT,
        date TEXT,
        rating REAL,
        isRead INTEGER,
        imageUrl TEXT
      )
    ''');
  }


  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert('books', book.toMap());
  }

  Future<List<Book>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');

    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }
}
