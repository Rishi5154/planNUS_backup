import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/schedule_time.dart';
import 'day_schedule.dart';

class TimeTable {
  static List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static List<int> weekdays = [1, 2, 3, 4, 5, 6, 7];
  Map<int, DaySchedule> timetable;

  TimeTable() {
    timetable = {
    1 : DaySchedule(),
    2 : DaySchedule(),
    3 : DaySchedule(),
    4 : DaySchedule(),
    5 : DaySchedule(),
    6 : DaySchedule(),
    7 : DaySchedule(),
    };
  }

  Widget timeTableWidget() {
    return TimeTableWidget(tt: this);
  }

  void alter(String day, String bName, ScheduleTime bStart, ScheduleTime bEnd, bool isImportant) {
    int s = bStart.time;
    int e = bEnd.time;
    while (s < e) {
      ScheduleTiming t = ScheduleTiming(s);
      timetable[day].scheduler[t.toString()].alter(bName);
      if (isImportant) { timetable[day].scheduler[t.toString()].toggleImportant(); }
      else { timetable[day].scheduler[t.toString()].toggleNotImportant(); }
      s += 100;
    }
  }
}

class TimeTableWidget extends StatefulWidget {
  final TimeTable tt;
  TimeTableWidget({this.tt});

  @override
  TimeTableWidgetState createState() => TimeTableWidgetState(tt: this.tt);
}

class TimeTableWidgetState extends State<TimeTableWidget> {
  TimeTable tt;
  TimeTableWidgetState({this.tt});

  int hex(int startTime) {
    switch (startTime) {
      case 800: return 0; break;
      case 900: return 1; break;
      case 1000: return 2; break;
      case 1100: return 3; break;
      case 1200: return 4; break;
      case 1300: return 5; break;
      case 1400: return 6; break;
      case 1500: return 7; break;
      case 1600: return 8; break;
      case 1700: return 9; break;
      case 1800: return 10; break;
      case 1900: return 11; break;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: <Widget> [
                Row(
                    children: [
                      SizedBox(width: 32.5),
                      Row(
                          children: TimeTable.days.map((day) => Row(
                            children: <Widget> [
                              SizedBox(width: 6.0),
                              SizedBox(
                                  width: 50.0,
                                  child: Card(
                                    color: Colors.amberAccent,
                                    child: Text(
                                      day,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                              ),
                            ],
                          )).toList()
                      ),]
                ),
                Column(
                    children: [
                      Column(
                        children: ScheduleTiming.allSlots.map((slot) => Container(
                          color: Colors.white30,
                          child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 2.5),
                                    Card(
                                      color: Colors.blue,
                                      child: Column(
                                          children: [
                                            Text(ScheduleTime(time: slot.start).toString(), style: TextStyle(fontSize: 10.0)),
                                            Text("-", style: TextStyle(fontSize: 12.0)),
                                            Text(ScheduleTime(time: slot.end).toString(), style: TextStyle(fontSize: 10.0)),
                                          ]
                                      ),
                                    ),
                                    Row(
                                        children: tt.timetable.values.map((ds) => Row(children: [ SizedBox(width: 6.0),
                                          ds.scheduler[slot.toString()].weeklyActivityTemplate()])).toList()
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                              ]
                          ),
                        )
                        ).toList(),
                      ),
                    ]
                ),
              ],
            ),
          ),
        ));
  }
}
