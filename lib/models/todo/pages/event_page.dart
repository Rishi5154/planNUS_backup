import 'package:flutter/material.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/models/timetable/day_schedule.dart';
import 'package:plannusandroidversion/models/timetable/schedule_timing.dart';
import 'package:plannusandroidversion/models/timetable/timetable_event.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_icon_decoration.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class DayEvent {
  final String time;
  final String task;
  String desc;
  bool isFinish;
  bool isImportant;
  String location;

  DayEvent(this.time, this.task, this.desc, this.isFinish, this.isImportant, {this.location});
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
  static List<ScheduleTiming> _orderedTime = Constants.visibleTiming;
  static List<int> indexes = [0,1,2,3,4,5,6,7,8,9,10,11];
  @override
  Widget build(BuildContext context) {
    double iconSize = 20;
    DateTime now = DateTime.now();
    DaySchedule ds = Provider.of<User>(context).timetable.timetable[DateTime(now.year, now.month, now.day)] ?? DaySchedule.noSchedule;
    List<DayEvent> _eventList = indexes.map((val) {
      String m = _orderedTime[val].toString();
      TimeTableEvent act = ds.ds[val];
      if (act == null) {
        return null;
      } else {
        String time = m.substring(0, 2) + ":" + m.substring(2, 4);
        String task = act.name;
        String desc = "";
        bool isFinish = now.hour >= act.timing.end;
        bool isImportant = act.isImportant;
        String location = act.location;
        return act.location == null ? new DayEvent(time, task, desc, isFinish, isImportant)
            : new DayEvent(time, task, desc, isFinish, isImportant, location: location);
//        return new DayEvent(time, task, desc, isFinish, isImportant, location: location);
      }
    }).toList();

    _eventList.removeWhere((val) => val == null);

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

  Widget _displayContent(DayEvent event) {
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
              Text(event.location != null ? event.location : event.desc),
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