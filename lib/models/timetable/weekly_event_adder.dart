import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plannusandroidversion/models/timetable/activity.dart';
import 'package:plannusandroidversion/models/timetable/schedule_timing.dart';
import 'package:plannusandroidversion/models/timetable/weekly_event.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_date_time_picker.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_textfield.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';

class WeeklyEventAdder extends StatefulWidget {
  @override
  _WeeklyEventAdderState createState() => _WeeklyEventAdderState();
}

class _WeeklyEventAdderState extends State<WeeklyEventAdder> {

  static List<DropdownMenuItem<TimeOfDay>> buildDropDownMenuItems(List<TimeOfDay> times) {
    List<DropdownMenuItem<TimeOfDay>> items = List();
    for (TimeOfDay t in times) {
      items.add(
        DropdownMenuItem(
          value: t,
          child: Text(t.toString().substring(10, 15)),
        ),
      );
    }
    return items;
  }

  static List<DropdownMenuItem<int>> buildDropDownMenuItems2(List<String> days) {
    List<DropdownMenuItem<int>> items = List();
    for (int i = 0; i < 7; i++) {
      items.add(
        DropdownMenuItem(
          value: i + 1,
          child: Text(days[i]),
        ),
      );
    }
    return items;
  }
  static List<TimeOfDay> startTimeList = [
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 17, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 19, minute: 0),
  ];

  static List<TimeOfDay> endTimeList = [
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 17, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 19, minute: 0),
    TimeOfDay(hour: 20, minute: 0),
  ];


  List<DropdownMenuItem<int>> _dropdownDays = buildDropDownMenuItems2(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']);
  List<DropdownMenuItem<TimeOfDay>> _dropdownStartTimes = buildDropDownMenuItems(startTimeList);
  List<DropdownMenuItem<TimeOfDay>> _dropdownEndTimes= buildDropDownMenuItems(endTimeList);
  TextEditingController _selectedName = new TextEditingController();
  TimeOfDay _selectedStartTime;
  TimeOfDay _selectedEndTime;
  int _selectedDay;
  bool _selectedImportance = false;
  String error = '';
  String addable = '';
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  bool isWeeklyEvent = false;

  void init() {
    _selectedName = null;
    _selectedStartTime = null;
    _selectedEndTime = null;
    _selectedImportance = null;
    _selectedDay = null;
    error = '';
    addable = '';
  }

  int day(String selected) {
    switch(selected) {
      case 'Mon': return 1; break;
      case 'Tue': return 2; break;
      case 'Wed': return 3; break;
      case 'Thu': return 4; break;
      case 'Fri': return 5; break;
      case 'Sat': return 6; break;
      case 'Sun': return 7; break;
      default: return 0; break;
    }
  }

  onChangeImportance(bool choice) {
    setState(() {
      _selectedImportance = choice;
    });
  }
  static const int START = 0;
  static const int END = 1;

  Future _pickDate(int startOrEnd) async {
    DateTime datePicked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().add(Duration(days: -365)),
        lastDate: new DateTime.now().add(Duration(days: 365)));
    if (datePicked != null)
      setState(() {
        if (startOrEnd == START) {
          _selectedStartDate = datePicked;
        } else if (startOrEnd == END){
          _selectedEndDate = datePicked;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
              child: CustomTextField(labelText: "What activity is it?", controller: _selectedName,)
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
                onChanged: (val) {
                  setState(() {
                    _selectedStartTime = val;
                  });
                },
              ),
            ),
            SizedBox(height: 8.0),
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
                onChanged: (val) {
                  if (val.hour <= _selectedStartTime.hour) {
                    setState((){
                      error = "Inappropriate End Time!";
                    });
                  } else {
                    setState(() {
                      error = '';
                      _selectedEndTime = val;
                    });
                  }
                },
              ),
            ),
            error != '' ? Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ) : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Is it important?"),
                Switch(
                  value: _selectedImportance,
                  onChanged: (val) {
                    setState(() {
                      _selectedImportance = val;
                    });
                  },
                  activeTrackColor: Colors.red,
                  activeColor: Colors.white,
                ),
                Text(_selectedImportance ? 'Yes' : 'No'),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isWeeklyEvent ? 'From: ': 'Date: '),
                  CustomDateTimePicker(
                    icon: Icons.date_range,
                    onPressed: () {return _pickDate(START);},
                    value: new DateFormat("dd-MM-yyyy").format(_selectedStartDate),
                  ),
                  Switch(
                      value: isWeeklyEvent,
                      onChanged: (bool e) {
                        setState(() {
                          this.isWeeklyEvent = e;
                        });
                      }
                  ),
                  Text(isWeeklyEvent ? 'Weekly' : 'One-time')
                ]
            ),
            isWeeklyEvent ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('To: '),
                CustomDateTimePicker(
                  icon: Icons.date_range,
                  onPressed: () {return _pickDate(END);},
                  value: new DateFormat("dd-MM-yyyy").format(_selectedEndDate),
                ),
                SizedBox(width: 90.0)
              ],
            ) : Container(),
            isWeeklyEvent ? Column(
              children: <Widget>[
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
              ],
            ) : Container(),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    child: Text("Add"),
                    onPressed: () async {
                      if (_selectedImportance == null || _selectedEndTime == null ||
                          _selectedStartTime == null || _selectedName.text == null ||
                          _selectedName.text == '' ||
                          (isWeeklyEvent && _selectedDay == null)) {
                        setState(() {
                          addable = 'Please fill in all fields!';
                        });
                      } else if (isWeeklyEvent
                          && _selectedStartDate.year == _selectedEndDate.year
                          && _selectedStartDate.month == _selectedEndDate.month
                          && _selectedStartDate.day == _selectedEndDate.day
                      ) {
                        setState(() {
                          addable = 'Invalid End Date';
                        });
                      }
                      else {
                        if (isWeeklyEvent) {
                          print(_selectedStartDate.weekday.toString() + "////////" + _selectedDay.toString());
                          if (_selectedStartDate.weekday > _selectedDay) {
                            _selectedStartDate = _selectedStartDate.add(Duration(days: 7 - (_selectedStartDate.weekday - _selectedDay)));
                          } else if (_selectedStartDate.weekday < _selectedDay) {
                            _selectedStartDate = _selectedStartDate.add(Duration(days: _selectedDay - _selectedStartDate.weekday));
                          }
                          user.timetable.addWeekly(WeeklyEvent(
                              _selectedDay,
                              ScheduleTiming(_selectedStartTime.hour,
                                  _selectedEndTime.hour),
                              _selectedName.text + _selectedStartDate.toIso8601String(),
                              _selectedName.text,
                              _selectedImportance,
                            _selectedStartDate,
                            _selectedEndDate,
                          ));
                        } else {
                          user.timetable.addActivity(Activity(
                            _selectedStartDate,
                            ScheduleTiming(_selectedStartTime.hour, _selectedEndTime.hour),
                            _selectedName.text + _selectedStartDate.toIso8601String(),
                            _selectedName.text,
                            _selectedImportance
                          ));
                        }
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
      ),
    );
  }
}
