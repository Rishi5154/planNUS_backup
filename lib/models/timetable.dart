import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/schedule_time.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';
import 'day_schedule.dart';

//void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: TimeTableWidget(new User())));

part 'timetable.g.dart';

@JsonSerializable(explicitToJson: true)
class TimeTable {
  static List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static List<int> weekdays = [1, 2, 3, 4, 5, 6, 7];
  Map<String, Map<String, Map<String, Object>>> timetable;

  TimeTable(Map<String, Map<String, Map<String, Object>>> timetable) {
    this.timetable = timetable;
  }

  static TimeTable emptyTimeTable() {
    return new TimeTable({
          '1' : DaySchedule.noSchedule().scheduler, //Monday
          '2' : DaySchedule.noSchedule().scheduler, //Tuesday
          '3' : DaySchedule.noSchedule().scheduler, //Wednesday
          '4' : DaySchedule.noSchedule().scheduler, //Thursday
          '5' : DaySchedule.noSchedule().scheduler, //Friday
          '6' : DaySchedule.noSchedule().scheduler, //Saturday
          '7' : DaySchedule.noSchedule().scheduler, //Sunday
    });
  }

  Widget timeTableWidget() {
    return TimeTableWidget();
  }

  void alter(String day, String bName, ScheduleTime bStart, ScheduleTime bEnd, bool isImportant) {
    int s = bStart.time;
    int e = bEnd.time;
    while (s < e) {
      ScheduleTiming t = ScheduleTiming(s);
      timetable[day][t.toString()]['name'] = bName;
      timetable[day][t.toString()]['isImportant'] = isImportant;
      s += 100;
    }
  }

  factory TimeTable.fromJson(Map<String, dynamic> data) => _$TimeTableFromJson(data);

  Map<String, dynamic> toJson() => _$TimeTableToJson(this);
}

class TimeTableWidget extends StatefulWidget {
  @override
  TimeTableWidgetState createState() => TimeTableWidgetState();
}

class TimeTableWidgetState extends State<TimeTableWidget> {
  TimeTable tt;
  User user;
//  ScrollController _sc;

  @override
  void initState() {
    super.initState();
//    _sc = ScrollController();
  }

  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    tt = user.timetable;
    return Stack(
      children: <Widget>[
        ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0) {
              return SizedBox(
                height: 28.0,
              );
            } else {
              String timeSlot = ScheduleTiming.allSlots[index-1].toString();
                return Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Card(
                        color: Colors.blue,
                        child: SizedBox(
                            height: 50.0,
                            width: 40.0,
                            child: Column(
                                children: [
                                  Text(timeSlot.substring(0, 4),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15.0)),
                                  Text("-", style: TextStyle(fontSize: 12)),
                                  Text(timeSlot.substring(5), textAlign: TextAlign
                                      .center, style: TextStyle(fontSize: 15.0)),
                                ]
                            )
                        )
                    ),
                    ttRow('1', timeSlot),
                    ttRow('2', timeSlot),
                    ttRow('3', timeSlot),
                    ttRow('4', timeSlot),
                    ttRow('5', timeSlot),
                    ttRow('6', timeSlot),
                    ttRow('7', timeSlot),
                  ],
              ),
                );
            }
          },
          itemCount: 13,
        ),
        Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 47,
              ),
              DayTile('Mon'),
              DayTile('Tue'),
              DayTile('Wed'),
              DayTile('Thu'),
              DayTile('Fri'),
              DayTile('Sat'),
              DayTile('Sun'),
            ],
          ),
        ),
      ],
    );
  }

  Widget ttRow(String day, String slot) {
    return GestureDetector(
      child: ActivityTile(tt.timetable[day][slot.toString()]['name'], tt.timetable[day][slot.toString()]['isImportant']),
      onLongPress: () {
        _showPopupMenu(day, slot.toString());
      },
      onTapDown: _storePosition,
    );
  }

  var _tapPosition;

  _showPopupMenu(String _day, String _slot) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
      ),
      items: <PopupMenuEntry> [
        PopupMenuItem<bool>(
          value: true,
          child: FlatButton(
            child: Text("Delete"),
            onPressed: () async {
              setState(() {
                user.timetable.timetable[_day][_slot]['name'] = 'No Activity';
                user.timetable.timetable[_day][_slot]['isImportant'] = false;
              });
              await user.update().whenComplete(() => Navigator.pop(context));
            },
          ),
        ),
        PopupMenuItem<bool>(
          value: false,
          child: FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
        )
      ],
      elevation: 8.0,
    );
  }
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }
}

class DayTile extends StatelessWidget {
  final String day;
  DayTile(this.day);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.yellow,
        child: SizedBox(
            height: 20.0,
            width: 40,
            child: Text(day, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17.0))
        )
    );
  }
}

class ActivityTile extends StatefulWidget {
  final String name;
  final bool isImportant;
  ActivityTile(this.name, this.isImportant);
  @override
  ActivityCardState createState() => ActivityCardState();
}

class ActivityCardState extends State<ActivityTile> {
  String _name;
  bool _isImportant;
  @override
  Widget build(BuildContext context) {
    _name = widget.name;
    _isImportant = widget.isImportant;
    return Card(
      color: _name == 'No Activity'
          ? Colors.grey[200] : _isImportant
          ? Colors.red : Colors.lightGreenAccent[100],
      child: SizedBox(
        width: 40,
        height: 50.0,
        child: Center(
          child: Text(_name,
            style: TextStyle(
              fontSize: _name.length < 5
                  ? 13.5 :_name.length < 6
                  ? 12.5 : _name.length < 7
                  ? 11.5 : 10.5,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}