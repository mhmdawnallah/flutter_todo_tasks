import 'package:flutter_sqlite_local_storage/models/todo_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const DatabaseService instance = DatabaseService._();
  //Private Constructor This is will gonna singleton
  const DatabaseService._();

  static const String _todosTable = 'todos_table';
  static const String _colId = 'id';
  static const String _colName = 'name';
  static const String _colDate = 'date';
  static const String _colPriorityLevel = 'priority_level';
  static const String _colCompleted = 'completed';
  static Database? _db;
  Future<Database> get db async {
    _db ??= await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = dir.path + '/todo_list.db';
    final todoListDb = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("""
        CREATE TABLE $_todosTable(
          $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_colName TEXT,
          $_colDate TEXT,
          $_colPriorityLevel TEXT,
          $_colCompleted INTEGER
      )
        """);
      },
    );

    return todoListDb;
  }

//Create
  Future<Todo> insert(Todo todo) async {
    final db = await this.db;
    final id = await db.insert(_todosTable, todo.toMap());
    print("@" * 10);
    print(id);
    print("@" * 10);

    final todWithId = todo.copyWith(id: id);
    return todWithId;
  }

//Read
  Future<List<Todo>> getAllTodos() async {
    final db = await this.db;
    final todoData = await db.query(_todosTable, orderBy: '$_colDate DESC');
    return todoData.map((mapTodo) => Todo.fromMap(mapTodo)).toList();
  }

//Update
  Future<int> update(Todo todo) async {
    final db = await this.db;
    print("%" * 15);
    print(todo.id);
    print("%" * 15);
    await db.update(
      _todosTable,
      todo.toMap(),
      where: '$_colId = ?',
      whereArgs: [todo.id],
    );
    print("%" * 15);
    final todos = await getAllTodos();
    print(todos.map((e) => print(e.completed)));
    print("%" * 15);
    return 0;
  }

//Delete
  Future<int> delete(id) async {
    final db = await this.db;
    return await db.delete(
      _todosTable,
      where: '$_colId = ?',
      whereArgs: [id],
    );
  }
}
