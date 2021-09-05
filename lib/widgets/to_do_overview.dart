import 'package:flutter/material.dart';
import 'package:flutter_sqlite_local_storage/models/models.dart';

class TodoOverview extends StatelessWidget {
  final List<Todo> todos;

  const TodoOverview({Key? key, required this.todos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completedTodosCount =
        todos.where((element) => element.completed).toList().length;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "My Todos",
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '$completedTodosCount of ${todos.length} completed',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
