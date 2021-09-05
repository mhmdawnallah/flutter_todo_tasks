import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite_local_storage/models/models.dart';
import 'package:flutter_sqlite_local_storage/screens/add_todo_screen.dart';
import 'package:flutter_sqlite_local_storage/services/database_service.dart';
import 'package:intl/intl.dart';
import '../extensions/string_extension.dart';

class TodoTile extends StatelessWidget {
  final VoidCallback getAllTodos;
  late Todo todo;
  TodoTile({Key? key, required this.todo, required this.getAllTodos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completedTextDecoration =
        !todo.completed ? TextDecoration.none : TextDecoration.lineThrough;
    return ListTile(
      key: Key(todo.id.toString()),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => AddTodoScreen(
            updateTodos: getAllTodos,
            todo: todo,
          ),
        ),
      ),
      title: Text(
        todo.name,
        style: TextStyle(
          decoration: completedTextDecoration,
          fontSize: 18.0,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              DateFormat.MMMMEEEEd().format(todo.date),
              style: TextStyle(
                height: 1.3,
                decoration: completedTextDecoration,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              width: 80,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.5),
              decoration: BoxDecoration(
                color: _getColor(),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 4.0,
                  )
                ],
              ),
              child: Text(
                EnumToString.convertToString(todo.priorityLevel).capitalize(),
                style: TextStyle(
                  color: !todo.completed ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  decoration: completedTextDecoration,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      trailing: Checkbox(
        value: todo.completed,
        activeColor: _getColor(),
        onChanged: (value) async {
          print(value);
          print("(" * 10);
          print(todo.id);
          print("(" * 10);
          todo = todo.copyWith(completed: value);
          print("(" * 10);
          print(todo.id);
          print("(" * 10);
          int num = await DatabaseService.instance.update(todo);

          getAllTodos();
        },
      ),
    );
  }

  Color _getColor() {
    switch (todo.priorityLevel) {
      case PriorityLevel.low:
        return Colors.green;
      case PriorityLevel.medium:
        return Colors.orange[600]!;
      case PriorityLevel.high:
        return Colors.red[400]!;
    }
  }
}
