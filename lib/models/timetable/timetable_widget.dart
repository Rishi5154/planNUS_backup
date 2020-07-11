import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:plannusandroidversion/models/timetable/activity.dart';
import 'package:plannusandroidversion/models/timetable/day_schedule.dart';
import 'package:plannusandroidversion/models/timetable/timetable.dart';
import 'package:plannusandroidversion/models/timetable/timetable_event.dart';
import 'package:plannusandroidversion/models/timetable/weekly_event.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class TimeTableWidget extends StatefulWidget {
  @override
  _TimeTableWidgetState createState() => _TimeTableWidgetState();
}

class _TimeTableWidgetState extends State<TimeTableWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TimetableController<BasicEvent> _controller;

  Map<String, dynamic> myHashMap = {};

  List<BasicEvent> convert(TimeTable timetable) {
    final date = DateTime.now();
    DateTime refDate = DateTime(date.year, date.month, date.day);
    refDate = refDate.add(Duration(days: -7));
    List<BasicEvent> result = new List<BasicEvent>();
    for (int i = -7; i < 25; i ++) {
      List<TimeTableEvent> daySchedule = timetable.timetable[refDate] == null ? DaySchedule.noSchedule.ds : timetable.timetable[refDate].ds;
      int year = refDate.year;
      int month = refDate.month;
      int day = refDate.day;
      for (int j = 0; j < 12; j++) {
        dynamic a = daySchedule[j];
        if (a != null) {
          if (a is WeeklyEvent) {
            print(a.runtimeType);
          } else if (a is Activity) {
            print(a.runtimeType);
          } else {
            print(a.runtimeType);
          }
          BasicEvent we = BasicEvent(
              title: a.name,
              id: a.name + a.timing.toString(),
              color: a.isImportant ? Colors.redAccent : Colors.lightGreenAccent,
              start: LocalDateTime(year, month, day,
                  a.timing.start, 00, 00),
              end: LocalDateTime(
                  year, month, day,
                  a.timing.end, 00, 00)
          );
          result.add(we);
          myHashMap[we.id] = a;
          j += (a.timing.end - a.timing.start);
        }
      }
      refDate = refDate.add(Duration(days: 1));
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
  String _viewingMonth = DateFormat.MMMM('en_US').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    final today = LocalDate.today();
    LocalDate monday = today.dayOfWeek.value == 1 ? today : today.addDays(-today.dayOfWeek.value + 1);
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
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        //elevation: 0,
        backgroundColor: Colors.white70,
        title: ValueListenableBuilder<LocalDate>(
          valueListenable: _controller.dateListenable,
          builder: (context, date, _) =>
              Text(DateFormat.MMMM('en_US').format(date.toDateTimeUnspecified()), style: GoogleFonts.openSans(color: Colors.black),),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.today),
            onPressed: () => _controller.animateToToday(),
            tooltip: 'Jump to today',
            color: Colors.black,
          ),
        ],
      ),
      body: Timetable<BasicEvent>(
        controller: _controller,
        theme: TimetableThemeData(
          primaryColor: Colors.deepPurpleAccent,
          partDayEventMinimumDuration: Period(minutes: 60),
        ),
        onEventBackgroundTap: (start, isAllDay) {
          setState(() {
            _viewingMonth = _controller.scrollControllers.addAndGet().position.toString();
          });
        },
        eventBuilder: (event) {
          return TimeTableEventWidget(
            _scaffoldKey.currentContext,
            myHashMap[event.id],//MIGHT BE WRONG
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