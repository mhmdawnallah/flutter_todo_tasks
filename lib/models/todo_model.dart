import 'package:enum_to_string/enum_to_string.dart';

class Todo {
  final int? id;
  final String name;
  final DateTime date;
  final PriorityLevel priorityLevel;
  final bool completed;

  Todo(
      {this.id,
      required this.name,
      required this.date,
      required this.priorityLevel,
      required this.completed});

  Todo copyWith(
      {int? id,
      String? name,
      DateTime? dateTime,
      PriorityLevel? priorityLevel,
      bool? completed}) {
    print('from todo copywith');
    print(completed);

    return Todo(
      id: id ?? this.id,
      name: name ?? this.name,
      date: dateTime ?? date,
      priorityLevel: priorityLevel ?? this.priorityLevel,
      completed: completed ?? this.completed,
    );
  }

//Store Into Sqlite Database Storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'priority_level': EnumToString.convertToString(priorityLevel),
      'completed': completed ? 1 : 0,
    };
  }

//Retrieve From Sqlite Database Storage
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
        id: map['id'] as int,
        name: map['name'] as String,
        date: DateTime.parse(map['date'] as String),
        priorityLevel: EnumToString.fromString(
            PriorityLevel.values, map['priority_level'] as String)!,
        completed: map['completed'] as int == 1);
  }
}

enum PriorityLevel { low, medium, high }
