import 'package:flutter/material.dart';
import 'package:flutter_sqlite_local_storage/models/models.dart';
import 'package:flutter_sqlite_local_storage/screens/screens.dart';
import 'package:flutter_sqlite_local_storage/services/database_service.dart';
import 'package:flutter_sqlite_local_storage/widgets/widgets.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  List<Todo> _todos = [];
  @override
  void initState() {
    print("Hello World");
    super.initState();
    _getTodos();
  }

  Future<void> _getTodos() async {
    final todos = await DatabaseService.instance.getAllTodos();

    if (mounted) {
      setState(() => _todos = todos);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Hi");
    print("Hello World");
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => AddTodoScreen(
                  updateTodos: _getTodos,
                ))),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          physics: const BouncingScrollPhysics(),
          itemCount: 1 + _todos.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            if (index == 0) {
              return TodoOverview(todos: _todos);
            }

            return TodoTile(
              todo: _todos[index - 1],
              getAllTodos: _getTodos,
            );
          },
        ),
      ),
    );
  }
}
