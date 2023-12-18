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

  static const String tableBooks = 'books';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnAuthor = 'author';
  static const String columnGenre = 'genre';
  static const String columnDate = 'date';
  static const String columnImageUrl = 'imageUrl';
  static const String columnDescription = 'description';
  static const String columnStatus = 'status';

  Future<void> _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableBooks (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT,
        $columnAuthor TEXT,
        $columnGenre TEXT,
        $columnDate TEXT,
        $columnImageUrl TEXT,
        $columnDescription TEXT,
        $columnStatus TEXT
      )
    ''');
  }

  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert(tableBooks, book.toMap());
  }

  Future<List<Book>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableBooks);

    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(tableBooks, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateBook(Book book) async {
    final db = await database;
    return await db.update(
      tableBooks,
      book.toMap(),
      where: '$columnId = ?',
      whereArgs: [book.id],
    );
  }
}
