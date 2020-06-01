import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:plannusandroidversion/models/todo/todo_models/database.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_modal_action_button.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_date_time_picker.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_textfield.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo.dart';
import 'package:plannusandroidversion/models/user.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  final _textTaskControler = TextEditingController();

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
    User user = Provider.of<User>(context);
    _textTaskControler.clear();
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
          CustomTextField(
              labelText: 'Enter task name', controller: _textTaskControler),
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
              if (_textTaskControler.text == "") {
                print("data not found");
              } else {
                await user.toDoDatabase
                    .insertTodoEntries(new TodoData(
                      date: _selectedDate,
                      time: DateTime.now(),
                      isFinish: false,
                      task: _textTaskControler.text,
                      description: "",
                      todoType: TodoType.TYPE_TASK.index,
                      id: null)
                    )
                    .whenComplete(() => user.update())
                    .whenComplete(() => Navigator.pop(context));
              }
            },
          )
        ],
      ),
    );
  }
}