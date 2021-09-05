import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite_local_storage/models/models.dart';
import 'package:flutter_sqlite_local_storage/services/database_service.dart';
import 'package:intl/intl.dart';
import '../extensions/string_extension.dart';

class AddTodoScreen extends StatefulWidget {
  final VoidCallback updateTodos;
  final Todo? todo;
  const AddTodoScreen({Key? key, required this.updateTodos, this.todo})
      : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dateController;

  Todo? _todo;
  bool get _isEditing => widget.todo != null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_isEditing) {
      _todo = widget.todo;
    } else {
      _todo = Todo(
        name: 'First Task',
        date: DateTime.now(),
        priorityLevel: PriorityLevel.medium,
        completed: false,
      );
    }
    _nameController = TextEditingController(text: _todo!.name);
    _dateController =
        TextEditingController(text: DateFormat.MMMMEEEEd().format(_todo!.date));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            !_isEditing ? "Add Todo" : "Update Todo",
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 40.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    labelText: "Name",
                  ),
                  validator: (value) =>
                      value!.trim().isEmpty ? "Please enter a name" : null,
                  onSaved: (value) => _todo = _todo!.copyWith(name: value),
                ),
                SizedBox(
                  height: 32,
                ),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    labelText: "Date",
                  ),
                  onTap: _handleDatePicker,
                ),
                SizedBox(
                  height: 32,
                ),
                DropdownButtonFormField<PriorityLevel>(
                    value: _todo!.priorityLevel,
                    icon: Icon(Icons.arrow_drop_down_circle),
                    iconSize: 22.0,
                    iconEnabledColor: Theme.of(context).primaryColor,
                    items: PriorityLevel.values
                        .map(
                          (priorityLevel) => DropdownMenuItem(
                            value: priorityLevel,
                            child: Text(
                              EnumToString.convertToString(priorityLevel)
                                  .capitalize(),
                            ),
                          ),
                        )
                        .toList(),
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Priority Level",
                    ),
                    onChanged: (value) {
                      print('hello1');
                      print(value);
                      setState(
                        () {
                          _todo = _todo!.copyWith(priorityLevel: value);
                        },
                      );
                      print('hello2');
                      print(_todo!.priorityLevel);
                    }),
                SizedBox(
                  height: 32.0,
                ),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(!_isEditing ? "Add" : "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  style: ElevatedButton.styleFrom(
                    primary: !_isEditing ? Colors.green : Colors.orange,
                    minimumSize: Size.fromHeight(45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                if (_isEditing)
                  ElevatedButton(
                    onPressed: () {
                      DatabaseService.instance.delete(_todo!.id);
                      widget.updateTodos();
                      Navigator.of(context).pop();
                    },
                    child: Text("Delete",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _todo!.date,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) {
      _dateController.text = DateFormat.MMMMEEEEd().format(date);
      setState(() {
        _todo = _todo!.copyWith(dateTime: date);
      });
      print(_todo!.date);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (!_isEditing) {
        DatabaseService.instance.insert(_todo!);
      } else {
        DatabaseService.instance.update(_todo!);
      }
      widget.updateTodos();
      Navigator.of(context).pop();
    }
  }
}
