import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'activity.dart';
import 'schedule_time.dart';

//void main() => runApp(MaterialApp(
//  home: DayScheduleWidget(ds: new DaySchedule()),
//));

class DaySchedule {
  static final List<ScheduleTime> startTimes = ScheduleTime.startTimeList;
  static final List<ScheduleTime> endTimes = ScheduleTime.endTimeList;
  static final List<ScheduleTiming> allTimings = ScheduleTiming.allSlots;
//  List<Activity> schedule = ScheduleTiming.allSlots
//      .map((slot) => Activity.noActivity(slot)).toList();
  Map<String, Activity> scheduler = {
    allTimings[0].toString() : Activity.noActivity(allTimings[0]),
    allTimings[1].toString() : Activity.noActivity(allTimings[1]),
    allTimings[2].toString() : Activity.noActivity(allTimings[2]),
    allTimings[3].toString() : Activity.noActivity(allTimings[3]),
    allTimings[4].toString() : Activity.noActivity(allTimings[4]),
    allTimings[5].toString() : Activity.noActivity(allTimings[5]),
    allTimings[6].toString() : Activity.noActivity(allTimings[6]),
    allTimings[7].toString() : Activity.noActivity(allTimings[7]),
    allTimings[8].toString() : Activity.noActivity(allTimings[8]),
    allTimings[9].toString() : Activity.noActivity(allTimings[9]),
    allTimings[10].toString() : Activity.noActivity(allTimings[10]),
    allTimings[11].toString() : Activity.noActivity(allTimings[11]),
    };

  Widget dsWidget() {
    return DayScheduleWidget(ds: this);
  }
}

class DayScheduleWidget extends StatefulWidget {
  final DaySchedule ds;
  DayScheduleWidget({this.ds});

  @override
  DayScheduleWidgetState createState() {
    return DayScheduleWidgetState(ds: this.ds);
  }
}

class DayScheduleWidgetState extends State<DayScheduleWidget> {
  DaySchedule ds;
  DayScheduleWidgetState({this.ds});

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

  void alter(String bName, int bStart, int bEnd, bool isImportant) {
    int s = bStart;
    int e = bEnd;
    while (s < e) {
      ScheduleTiming t = ScheduleTiming(s);
      ds.scheduler[t.toString()].alter(bName);
      if (isImportant) { ds.scheduler[t.toString()].toggleImportant(); }
      else { ds.scheduler[t.toString()].toggleNotImportant(); }
      s += 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: ds.scheduler.values.map((s) => s.dailyActivityTemplate()).toList(),
      )
    );
  }
}
