import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo_data.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:provider/provider.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_modal_action_button.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_date_time_picker.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  final _textTaskController = TextEditingController();

  Future _pickDate() async {
    DateTime datepick = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().add(Duration(days: -365)),
        lastDate: new DateTime.now().add(Duration(days: 365)));
    if (datepick != null)
      setState(() {
        _selectedDate = datepick;
      });
  }

  @override
  Widget build(BuildContext context) {
    _textTaskController.clear();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
              child: Text(
                "Add new task",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
          SizedBox(
            height: 24,
          ),
          TextFormField(
            key: Key('Task name'),
              decoration: InputDecoration(
              hintText: 'Enter task name',
//              icon: Icon(Icons.assignment, color: Colors.blue),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300], width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
              )
          ), controller: _textTaskController),
          SizedBox(height: 12),
          CustomDateTimePicker(
            icon: Icons.date_range,
            onPressed: _pickDate,
            value: new DateFormat("dd-MM-yyyy").format(_selectedDate),
          ),
          SizedBox(
            height: 24,
          ),
          CustomModalActionButton(
            onClose: () {
              Navigator.of(context).pop();
            },
            onSave: () async {
              if (_textTaskController.text == "") {
                print("data not found");
              } else {
                TodoData updated = await DatabaseMethods(uid: Provider.of<User>(context, listen: false).uid).getUserTodoData();
              await updated.updateAdds(context, new Todo(
                date: _selectedDate,
                time: DateTime.now(),
                isFinish: false,
                task: _textTaskController.text,
                description: "",
                todoType: TodoType.TYPE_TASK.index,
                id: updated.count
              )).whenComplete(() => Navigator.pop(context));
              }
            },
          )
        ],
      ),
    );
  }
}