import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_date_time_picker.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_modal_action_button.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_textfield.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  String _selectedDate = 'Pick date';
  String _selectedTime = 'Pick time';

  Future _pickDate() async {
    DateTime datePicked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().add(Duration(days: -365)),
        lastDate: new DateTime.now().add(Duration(days: 365)));
    if (datePicked != null)
      setState(() {
        _selectedDate = datePicked.toString();
      });
  }

  Future _pickTime() async {
    TimeOfDay timePicked = await showTimePicker(
        context: context, initialTime: new TimeOfDay.now());
    if (timePicked != null) {
      setState(() {
        _selectedTime = timePicked.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
              child: Text(
                "Add new event",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
          SizedBox(
            height: 24,
          ),
          CustomTextField(labelText: 'Enter event name'),
          SizedBox(height: 12),
          CustomTextField(labelText: 'Enter description'),
          SizedBox(height: 12),
          CustomDateTimePicker(
            icon: Icons.date_range,
            onPressed: _pickDate,
            value: _selectedDate,
          ),
          CustomDateTimePicker(
            icon: Icons.access_time,
            onPressed: _pickTime,
            value: _selectedTime,
          ),
          SizedBox(
            height: 24,
          ),
          CustomModalActionButton(
            onClose: () {
              Navigator.of(context).pop();
            },
            onSave: () {},
          )
        ],
      ),
    );
  }
}

