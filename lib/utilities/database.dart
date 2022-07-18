import 'package:intern_todo/models/todo_item.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  Database? db;

  factory DatabaseHelper() {
    return _helper;
  }

  static final DatabaseHelper _helper = DatabaseHelper._internal();

  DatabaseHelper._internal();

  Future<Database> loadDatabase() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var databasesPath = await databaseFactoryFfi.getDatabasesPath();
    String path = join(databasesPath, 'todo_database.db');
    db = await databaseFactory.openDatabase(path);

    try {
      await db!.execute(
        'CREATE TABLE items(id INTEGER PRIMARY KEY, description TEXT, deadline TEXT, is_finished INTEGER, completed_date TEXT)',
      );
    } on Exception {
      print("Table exists");
    }

    return db!;
  }

  void saveItemToDatabase(TodoItem item) async {
    if (db != null) {
      if (item.id == null) {
        await db!.insert('items', item.toMap());
      } else {
        await db!.update('items', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
      }
    }
  }

  Future<List<TodoItem>> loadAllTodoItems() async {
    if (db == null) {
      await loadDatabase();
    }
    //Get the list of Todo Items that are stored in the db
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db!.query('items');

    // Convert the List<Map<String, dynamic> into a List<TodoItems>.
    return List.generate(maps.length, (i) {
      return TodoItem.fromMap(maps[i]);
    });
  }
}
