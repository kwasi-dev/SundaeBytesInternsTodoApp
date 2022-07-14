import 'package:intern_todo/models/todo_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? db;

  DatabaseHelper() {
    loadDatabase();
  }

  void loadDatabase() async {
    db = await openDatabase(join('todo_datbase.db'), onCreate: ((db, version) {
      //Run the create statement to create our item table
      //CRUD
      //C - create
      //R - read
      //U - UPDATE
      //D - delete

      return db.execute(
        'CREATE TABLE items(id INTEGER PRIMARY KEY, description TEXT, deadline TEXT, is_finished INTEGER, completed_date TEXT)',
      );
    }), version: 1);
  }

  void saveItemToDatabase(TodoItem item) async {
    if (db != null) {
      await db!.insert('items', item.toMap());
    }
  }

  Future<List<TodoItem>> loadAllTodoItems() async {
    //Get the list of Todo Items that are stored in the db
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db!.query('items');

    // Convert the List<Map<String, dynamic> into a List<TodoItems>.
    return List.generate(maps.length, (i) {
      return TodoItem.fromMap(maps[i]);
    });
  }
}
