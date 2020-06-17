import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/activity.dart';
import 'package:plannusandroidversion/models/day_schedule.dart';
import 'package:plannusandroidversion/models/schedule_time.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_icon_decoration.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class Event {
  final String time;
  final String task;
  String desc;
  bool isFinish;
  bool isImportant;

  Event(this.time, this.task, this.desc, this.isFinish, this.isImportant);
}

//final List<Event> _eventList = [
//  new Event("08:00", "Have coffe with Sam", "Personal", true),
//  new Event("10:00", "Meet with sales", "Work", true),
//  new Event("12:00", "Call Tom about appointment", "Work", false),
//  new Event("14:00", "Fix onboarding experience", "Work", false),
//  new Event("16:00", "Edit API documentation", "Personal", false),
//  new Event("18:00", "Setup user focus group", "Personal", false),
//];

class _EventPageState extends State<EventPage> {
  static List<int> _orderedTime = DaySchedule.allTimings;
  @override
  Widget build(BuildContext context) {
    double iconSize = 20;
    DaySchedule ds = Provider.of<User>(context).timetable.timetable[DateTime.now().weekday - 1];
    List<Event> _eventList = _orderedTime.map((val) {
      String m = ScheduleTiming(val).toString();
      Activity act = ds.getActivity(val);
      String time = m.substring(0,2) + ":" + m.substring(2,4);
      String task = act.name;
      String desc = "";
      bool isFinish = act.isFinish;
      bool isImportant = act.isImportant;
      return new Event(time, task, desc, isFinish, isImportant);
    }).toList();
    return ListView.builder(
      itemCount: _eventList.length,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24),
          child: Row(
            children: <Widget>[
              _lineStyle(context, iconSize, index, _eventList.length,
                  _eventList[index].isFinish),
              _displayTime(_eventList[index].time),
              _displayContent(_eventList[index])
            ],
          ),
        );
      },
    );
  }

  Widget _displayContent(Event event) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(0, 3))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.task),
              SizedBox(
                height: 12,
              ),
              Text(event.desc)
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayTime(String time) {
    return Container(
        width: 80,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(time),
        ));
  }

  Widget _lineStyle(BuildContext context, double iconSize, int index,
      int listLength, bool isFinish) {
    return Container(
        decoration: CustomIconDecoration(
            iconSize: iconSize,
            lineWidth: 1,
            firstData: index == 0 ?? true,
            lastData: index == listLength - 1 ?? true),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 3),
                    color: Color(0x20000000),
                    blurRadius: 5)
              ]),
          child: Icon(
              isFinish
                  ? Icons.fiber_manual_record
                  : Icons.radio_button_unchecked,
              size: iconSize,
              color: Theme.of(context).accentColor),
        ));
  }
}