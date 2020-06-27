import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/models/timetable/activity.dart';
import 'package:plannusandroidversion/models/timetable/timetable.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';
import 'weekly_event.dart';

// ignore: unused_import
//import 'positioning_demo.dart';
//import 'utils.dart';

void main() async {
//  setTargetPlatformForDesktop();

  WidgetsFlutterBinding.ensureInitialized();
  await TimeMachine.initialize({'rootBundle': rootBundle});
  runApp(MaterialApp(home: TimetableExample()));
}

class TimetableExample extends StatefulWidget {
  @override
  _TimetableExampleState createState() => _TimetableExampleState();
}

class _TimetableExampleState extends State<TimetableExample> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TimetableController<WeeklyEvent> _controller;

  List<WeeklyEvent> convert(TimeTable timetable) {
    final now = DateTime.now();
    final today = now.weekday;
    final date = LocalDate.today();
    final monday = date.dayOfWeek.value == 1 ? date : date.addDays(-date.dayOfWeek.value + 1);
    List<WeeklyEvent> result = new List<WeeklyEvent>();
    for (int i = 0; i < 7; i ++) {
      List<Activity> daySchedule = timetable.timetable[i].ds;
      final dated = date.dayOfWeek.value > i ? date.addDays(-(date.dayOfWeek.value - i) + 1) : date.addDays(i - date.dayOfWeek.value + 1);
      for (int j = 0; j < 12; j++) {
        Activity a = daySchedule[j];
        if (a.name != 'No Activity') {
          WeeklyEvent we = WeeklyEvent(title: a.name,
              id: i.toString() + ',' + j.toString(),
              day: i+1,
              isImportant: a.isImportant,
              start: LocalDateTime(dated.year, dated.monthOfYear, dated.dayOfMonth,
                  Constants.allTimings[j] ~/ 100, 00, 00),
              end: LocalDateTime(
                  dated.year, dated.monthOfYear, dated.dayOfMonth,
                  1 + (Constants.allTimings[j] ~/ 100), 00, 00)
          );
          result.add(we);
        }
      }
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = LocalDate.today();
    final monday = today.dayOfWeek.value == 1 ? today : today.addDays(-today.dayOfWeek.value + 1);
    _controller = TimetableController(
      eventProvider: EventProvider.list(convert(Provider.of<User>(context).timetable)),
      initialTimeRange: InitialTimeRange.range(
        startTime: LocalTime(8, 0, 0),
        endTime: LocalTime(18, 0, 0),
      ),
      initialDate: monday,
      visibleRange: VisibleRange.days(7),
      firstDayOfWeek: DayOfWeek.monday,
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_controller.initialDate.monthOfYear.toString()),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.today),
            onPressed: () => _controller.animateToToday(),
            tooltip: 'Jump to today',
          ),
        ],
      ),
      body: Timetable<WeeklyEvent>(
        controller: _controller,
        onEventBackgroundTap: (start, isAllDay) {
          _showSnackBar('Background tapped $start is all day event $isAllDay');
        },
        eventBuilder: (event) {
          return WeeklyEventWidget(
            event,
          );
        },
//        allDayEventBuilder: (context, event, info) => BasicAllDayEventWidget(
//          event,
//          info: info,
//          onTap: () => _showSnackBar('All-day event $event tapped'),
//        ),
      ),
    );
  }

  void _showSnackBar(String content) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(content),
    ));
  }
}