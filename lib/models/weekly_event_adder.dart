import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_textfield.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';
import 'schedule_time.dart';

class WeeklyEventAdder extends StatefulWidget {
  @override
  _WeeklyEventAdderState createState() => _WeeklyEventAdderState();
}

class _WeeklyEventAdderState extends State<WeeklyEventAdder> {

  static List<DropdownMenuItem<ScheduleTime>> buildDropDownMenuItems(List<ScheduleTime> times) {
    List<DropdownMenuItem<ScheduleTime>> items = List();
    for (ScheduleTime t in times) {
      items.add(
        DropdownMenuItem(
          value: t,
          child: Text(t.toString()),
        ),
      );
    }
    return items;
  }
  static List<DropdownMenuItem<String>> buildDropDownMenuItems2(List<String> days) {
    List<DropdownMenuItem<String>> items = List();
    for (String t in days) {
      items.add(
        DropdownMenuItem(
          value: t,
          child: Text(t.toString()),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> _dropdownDays = buildDropDownMenuItems2(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']);
  List<DropdownMenuItem<ScheduleTime>> _dropdownStartTimes = buildDropDownMenuItems(ScheduleTime.startTimeList);
  List<DropdownMenuItem<ScheduleTime>> _dropdownEndTimes= buildDropDownMenuItems(ScheduleTime.endTimeList);
  TextEditingController _selectedName = new TextEditingController();
  ScheduleTime _selectedStartTime;
  ScheduleTime _selectedEndTime;
  String _selectedDay;
  bool _selectedImportance;
  String error = '';
  String addable = '';
  void init() {
    _selectedName = null;
    _selectedStartTime = null;
    _selectedEndTime = null;
    _selectedImportance = null;
    _selectedDay = null;
    error = '';
    addable = '';
  }

  String day(String selected) {
    switch(selected) {
      case 'Mon': return '1'; break;
      case 'Tue': return '2'; break;
      case 'Wed': return '3'; break;
      case 'Thu': return '4'; break;
      case 'Fri': return '5'; break;
      case 'Sat': return '6'; break;
      case 'Sun': return '7'; break;
      default: return '0'; break;
    }
  }

  onChangeStartTime(ScheduleTime selectedStartTime) {
    setState(() {
      _selectedStartTime = selectedStartTime;
    });
  }

  onChangeEndTime(ScheduleTime selectedEndTime) {
    if (selectedEndTime.time <= _selectedStartTime.time) {
      setState((){
        error = "Inappropriate End Time!";
      });
    } else {
      setState(() {
        error = '';
        _selectedEndTime = selectedEndTime;
      });
    }
  }

  onChangeImportance(bool choice) {
    setState(() {
      _selectedImportance = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
            child: CustomTextField(labelText: "What activity is it?", controller: _selectedName,)
          ),
          Text('Which day?'),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey[500])
              ),
            ),
            child: DropdownButton(
              focusColor: Colors.red,
              autofocus: true,
              value: _selectedDay,
              items: _dropdownDays,
              onChanged: (selectedDay) => setState(() {
                _selectedDay = selectedDay;
              }),
            ),
          ),
          Text("Start"),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey[500])
              ),
            ),
            child: DropdownButton(
              value: _selectedStartTime,
              items: _dropdownStartTimes,
              onChanged: onChangeStartTime,
            ),
          ),
          Text("End"),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey[500])
              ),
            ),
            child: DropdownButton(
              value: _selectedEndTime,
              items: _dropdownEndTimes,
              onChanged: onChangeEndTime,
            ),
          ),
          Text(
            error,
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
          Text("Is it important?"),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey[500])
              ),
            ),
            child: DropdownButton(
              value: _selectedImportance,
              items: <DropdownMenuItem<bool>>[
                DropdownMenuItem(
                    value: true,
                    child: Text("Yes")
                ),
                DropdownMenuItem(
                    value: false,
                    child: Text("No")
                )
              ],
              onChanged: onChangeImportance,
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text("Add"),
                  onPressed: () async {
                    if (_selectedImportance == null || _selectedEndTime == null ||
                        _selectedStartTime == null || _selectedName.text == null || _selectedDay == null) {
                      setState(() {
                        addable = 'Please fill in all fields!';
                      });
                    } else {
                      user.timetable.alter(day(_selectedDay), _selectedName.text,
                          _selectedStartTime, _selectedEndTime, _selectedImportance);
                      await user.update()
                          .whenComplete(() => init())
                          .whenComplete(() => Navigator.pop(context));
                    }
                  },
                ),
                SizedBox(width: 20.0),
                RaisedButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
              ]
          ),
          SizedBox(height: 10),
          Text(
            addable,
            style: TextStyle(
              color: Colors.red,
            )
          )
        ],
      ),
    );
  }
}
