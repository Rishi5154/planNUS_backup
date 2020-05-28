import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/schedule_time.dart';
import 'activity.dart';
import 'day_schedule.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: TimeTableWidget(tt: TimeTable.emptyTimeTable())));

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
    return TimeTableWidget(tt: this);
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
}

class TimeTableWidget extends StatefulWidget {
  final TimeTable tt;
  TimeTableWidget({this.tt});

  @override
  TimeTableWidgetState createState() => TimeTableWidgetState();
}

class TimeTableWidgetState extends State<TimeTableWidget> {
  TimeTable tt;
  ScrollController _sc;

  @override
  void initState() {
    super.initState();
    _sc = ScrollController();
  }

//  Widget timetable() {
//    return SingleChildScrollView(
//      scrollDirection: Axis.horizontal,
//      child: Row(
//        children: [
//          Column(
//              children: tt.timetable['1'].values.map((value) {
//                return Card(
//                    child: DecoratedBox(
//                        decoration: BoxDecoration(
//                          color: Colors.white,
//                        ),
//                        child: SizedBox(
//                          height: 50.0,
//                          width: 50.0,
//                          child: Text(value['name'], textAlign: TextAlign.center),
//                        )
//                    )
//                );
//              }).toList()
//          ),
//          Column(
//              children: tt.timetable['2'].values.map((value) {
//                return Card(
//                    child: DecoratedBox(
//                        decoration: BoxDecoration(
//                          color: Colors.white,
//                        ),
//                        child: SizedBox(
//                          height: 50.0,
//                          width: 50.0,
//                          child: Text(value['name'], textAlign: TextAlign.center,),
//                        )
//                    )
//                );
//              }).toList()
//          ),
//          Column(
//              children: tt.timetable['3'].values.map((value) {
//                return Card(
//                    child: DecoratedBox(
//                        decoration: BoxDecoration(
//                          color: Colors.white,
//                        ),
//                        child: SizedBox(
//                          height: 50.0,
//                          width: 50.0,
//                          child: Text(value['name'], textAlign: TextAlign.center,),
//                        )
//                    )
//                );
//              }).toList()
//          ),
//          Column(
//              children: tt.timetable['4'].values.map((value) {
//                return Card(
//                    child: DecoratedBox(
//                        decoration: BoxDecoration(
//                          color: Colors.white,
//                        ),
//                        child: SizedBox(
//                          height: 50.0,
//                          width: 50.0,
//                          child: Text(value['name'], textAlign: TextAlign.center,),
//                        )
//                    )
//                );
//              }).toList()
//          ),
//          Column(
//              children: tt.timetable['5'].values.map((value) {
//                return Card(
//                    child: DecoratedBox(
//                        decoration: BoxDecoration(
//                          color: Colors.white,
//                        ),
//                        child: SizedBox(
//                          height: 50.0,
//                          width: 50.0,
//                          child: Text(value['name'], textAlign: TextAlign.center,),
//                        )
//                    )
//                );
//              }).toList()
//          ),
//          Column(
//              children: tt.timetable['6'].values.map((value) {
//                return Card(
//                    child: DecoratedBox(
//                        decoration: BoxDecoration(
//                          color: Colors.white,
//                        ),
//                        child: SizedBox(
//                          height: 50.0,
//                          width: 50.0,
//                          child: Text(value['name'], textAlign: TextAlign.center,),
//                        )
//                    )
//                );
//              }).toList()
//          ),
//          Column(
//              children: tt.timetable['7'].values.map((value) {
//                return Card(
//                    child: DecoratedBox(
//                        decoration: BoxDecoration(
//                          color: Colors.white,
//                        ),
//                        child: SizedBox(
//                          height: 50.0,
//                          width: 50.0,
//                          child: Text(value['name'], textAlign: TextAlign.center,),
//                        )
//                    )
//                );
//              }).toList()
//          ),
//        ]
//      ),
//    );
//  }
//
//  Widget dayList() {
//    return Row(
//      children: TimeTable.days.map((day) {
//        Widget activity = Card(
//          margin: EdgeInsets.fromLTRB(4.0, 5.0, 4.0, 5.0),
//          child: DecoratedBox(
//              decoration: BoxDecoration(
//                color: Colors.amberAccent,
//              ),
//              child: SizedBox(
//                  height: 20.0,
//                  width: 50.0,
//                  child: Text(day, textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0))
//              )
//          ),
//        );
//        if (day == 'Mon') {
//          return Row(
//              children: [
//                SizedBox(width: 48),
//                activity
//              ]
//          );
//        } else {
//          return activity;
//        }
//      }).toList()
//    );
//  }
//
//  Widget timeList() {
//    return Column(
//        children: ScheduleTiming.allSlots.map((slot) {
//          return Card(
//            child: DecoratedBox(
//                decoration: BoxDecoration(
//                  color: Colors.blue,
//                ),
//                child: SizedBox(
//                    height: 50.0,
//                    width: 40.0,
//                    child: Column(
//                        children: [
//                          Text(ScheduleTime(time: slot.start).toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0)),
//                          Text("-", style: TextStyle(fontSize: 10)),
//                          Text(ScheduleTime(time: slot.end).toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0)),
//                        ]
//                    )
//                )
//            ),
//          );
//        }).toList()
//    );
//  }

  Widget build(BuildContext context) {
    tt = widget.tt;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: false,
              backgroundColor: Colors.white,
              pinned: true,
              title: Row(
                children: [
                  SizedBox(width: 30.0),
                  DayTile('Mon'),
                  DayTile('Tue'),
                  DayTile('Wed'),
                  DayTile('Thu'),
                  DayTile('Fri'),
                  DayTile('Sat'),
                  DayTile('Sun'),
                ]
              )
            ),
//            SliverGrid(
//              delegate: SliverChildBuilderDelegate((context, index) {
//                if (index == 0) {
//                  return SizedBox(
//                    width: 40.0
//                  );
//                } else {
//                  String day = TimeTable.days[index-1];
//                  Widget activity = Card(
//                    margin: EdgeInsets.fromLTRB(4.0, 5.0, 4.0, 5.0),
//                    child: DecoratedBox(
//                        decoration: BoxDecoration(
//                          color: Colors.amberAccent,
//                        ),
//                        child: SizedBox(
//                            height: 20.0,
//                            width: 50.0,
//                            child: Text(day, textAlign: TextAlign.center,
//                                style: TextStyle(fontSize: 20.0))
//                        )
//                    ),
//                  );
//                  return activity;
//                }
//              },
//              childCount: 8,
//              ),
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                crossAxisCount: 8,
//                childAspectRatio: 1.7,
//              ),
//            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index1) {
                ScheduleTiming slot = ScheduleTiming.allSlots[index1];
                return Container(
                  child: Row(
                    children: [
                      Card(
                          color: Colors.blue,
                          child: SizedBox(
                            height: 50.0,
                            width: 40.0,
                            child: Column(
                              children: [
                                Text(ScheduleTime(time: slot.start).toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0)),
                                Text("-", style: TextStyle(fontSize: 12)),
                                Text(ScheduleTime(time: slot.end).toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0)),
                              ]
                            )
                          )
                      ),
                      ActivityTile(tt.timetable['1'][slot.toString()]['name'], tt.timetable['1'][slot.toString()]['isImportant']),
                      ActivityTile(tt.timetable['2'][slot.toString()]['name'], tt.timetable['2'][slot.toString()]['isImportant']),
                      ActivityTile(tt.timetable['3'][slot.toString()]['name'], tt.timetable['3'][slot.toString()]['isImportant']),
                      ActivityTile(tt.timetable['4'][slot.toString()]['name'], tt.timetable['4'][slot.toString()]['isImportant']),
                      ActivityTile(tt.timetable['5'][slot.toString()]['name'], tt.timetable['5'][slot.toString()]['isImportant']),
                      ActivityTile(tt.timetable['6'][slot.toString()]['name'], tt.timetable['6'][slot.toString()]['isImportant']),
                      ActivityTile(tt.timetable['7'][slot.toString()]['name'], tt.timetable['7'][slot.toString()]['isImportant']),
                    ]
                  )
                );
              },
              childCount: 12),
            ),
          ]
        ),
      )
    );

//    return Scaffold(
//      appBar: AppBar(),
//      body: SingleChildScrollView(
//        scrollDirection: Axis.vertical,
//        child: Column(
//          children:[
//            dayList(),
//            Row(
//              children: [
//                timeList(),
//                SingleChildScrollView(
//                  scrollDirection: Axis.horizontal,
//                  child: timetable(),
//                ),
//              ]
//            ),
//          ]
//        ),
//      )
//    );
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
            width: 39.2,
            child: Text(day, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17.0))
        )
    );
  }
}

class ActivityTile extends StatelessWidget {
  final String name;
  final bool isImportant;
  ActivityTile(this.name, this.isImportant);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: name == 'No Activity' ? Colors.white70 : isImportant ? Colors.red : Colors.greenAccent,
      child: SizedBox(
          height: 50.0,
          width: 39.0,
          child: Center(
            child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.0
            )),
          )
      )
    );
  }
}