import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/timetable/activity.dart';
import 'package:plannusandroidversion/models/timetable/timetable_event.dart';
import 'package:plannusandroidversion/models/timetable/weekly_event.dart';
import 'package:plannusandroidversion/services/notificationservice.dart';
import 'activity.dart';
import 'day_schedule.dart';

//void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: TimeTableWidget(new User())));

part 'timetable.g.dart';

@JsonSerializable(explicitToJson: true)
class TimeTable {
  //static List<List<int>> notifIds = [[1,2,3,4,5,6,7,8,9,10,11,12]]

  //propeties
  Map<DateTime, DaySchedule> timetable = {};
  //Constructor
  TimeTable(this.timetable);

  static TimeTable emptyTimeTable() {
    return new TimeTable({});
  }

  // to generate notification id for easy identification of notifications
  int notificationIdGenerator(Activity activity) {
    DateTime threshold = new DateTime(2020, 7, 1, 0, 0);
    Duration diff = threshold.difference(activity.startDate);
    return diff.inHours;
  }

  int notificationIdGeneratorWeekly(WeeklyEvent event) {
    DateTime threshold = new DateTime(2020, 7, 1, 0, 0);
    Duration diff = threshold.difference(event.startDate);
    return 100000 + diff.inHours;
  }
//
//  int weeklyNotifactionIdGenerator (WeeklyEvent a)

  bool addable(WeeklyEvent event) {
    DateTime startDate = event.startDate;
    DateTime endDate = event.endDate;
    DateTime refDate = startDate.weekday > event.day
        ? startDate.add(Duration(days: 7 - (startDate.weekday - event.day)))
        : startDate.add(Duration(days: event.day - startDate.weekday));
    bool tracker = true;
    while (refDate.isBefore(endDate)) {
      DateTime index = DateTime(refDate.year, refDate.month, refDate.day);
      DaySchedule ref = timetable[index];
      if (ref != null && !ref.addable(event)) {
        tracker = false;
      }
      refDate = refDate.add(Duration(days: 7));
    }
    return tracker;
  }

  void addActivity(Activity event) {
    NotificationService notificationService = new NotificationService();
    DateTime index = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
    DaySchedule ref = timetable[index];
    if (ref == null) {
      ref = DaySchedule.noSchedule;
    }
    ref.addEvent(event);
    timetable[index] = ref;
    if (event.isImportant) {
      DateTime curr = DateTime.now();
      int startTime = event.timing.start;
      DateTime startDay = event.startDate;
      notificationService.scheduleAtTime(DateTime(startDay.year, startDay.month, startDay.day, startTime - 1, 45), notificationIdGenerator(event), "Important Event",
          "${event.name} is coming up soon!");
//      if (event.startDate.weekday > curr.weekday) {
//        DateTime future = curr.add(new Duration(days: event.startDate.weekday - curr.weekday)); // with days added to account for changes in month
//        print(future.weekday.toString() + " at day > curr.weekday");
//        print(future.day.toString() + " at day > curr.weekday");
//        print(future.month.toString() + " at day > curr.weekday");
////          print(s);
//        notificationService.scheduleAtTime(DateTime(future.year, future.month, future.day, startTime - 1, 45),
//            notificationIdGenerator(startTime, event.startDate.weekday), "Important Event", "${event.name} is coming up soon!");
//      } else if (curr.weekday == event.startDate.weekday) {
//        DateTime future = curr.add(new Duration(days: 7)); // with days added to account for changes in month
//        print(future.weekday.toString() + " at curr.weekday == day");
//        print(future.day.toString() + " at curr.weekday == day");
//        print(future.month.toString() + " at curr.weekday == day");
////          print(s);
//        curr.hour > startTime ? notificationService.scheduleAtTime(DateTime(future.year, future.month,
//            future.day, startTime - 1, 45), notificationIdGenerator(startTime, event.startDate.weekday), "Important Event", "${event.name} is coming up soon!")
//            :  notificationService.scheduleAtTime(DateTime(curr.year, curr.month,
//            curr.day, startTime - 1, 45), notificationIdGenerator(startTime, event.startDate.weekday), "Important Event", "${event.name} is coming up soon!");
//      } else {
//        DateTime future = curr.add(new Duration(days: event.startDate.weekday + 7 - curr.weekday)); // with days added to account for changes in month
//        print(future.weekday.toString() + " at curr.weekday < day");
//        print(future.day.toString() + " at curr.weekday < day");
//        print(future.month.toString() + " at curr.weekday < day");
//        notificationService.scheduleAtTime(DateTime(future.year, future.month, future.day, startTime - 1, 45),
//            notificationIdGenerator(startTime, event.startDate.weekday), "Important Event", "${event.name} is coming up soon!");
//      }
    }
  }

  void addWeekly(WeeklyEvent event) {
    NotificationService notificationService = new NotificationService();
//    DaySchedule ref = timetable[DateTime(event.startDate.year, event.startDate.month, event.startDate.day)];
    if (addable(event)) {
      DateTime startDate = event.startDate;
      DateTime endDate = event.endDate;
      DateTime refDate = startDate.weekday > event.day
          ? startDate.add(Duration(days: 7 - (startDate.weekday - event.day)))
          : startDate.add(Duration(days: event.day - startDate.weekday));
      DateTime refEnd = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 0);
      while (!refDate.isAfter(refEnd)) {
        DateTime index = DateTime(refDate.year, refDate.month, refDate.day);
        DaySchedule ref = timetable[index];
        if (ref == null) {
          ref = DaySchedule.noSchedule;
        }
        ref.addEvent(event);
        timetable[index] = ref;

        refDate = refDate.add(Duration(days: 7));
      }
      int startTime = event.timing.start;//int.parse(event.timing.start.toString().substring(0, s.toString().length - 2));
      print(event.timing.start.toString() + " starting time of the activity");
      DateTime startDay = event.startDate;
      print(Timestamp.now().toDate().weekday/*toLocal().toString()*/);
      //flutterLocalNotificationsPlugin.

      if (event.isImportant) {
        notificationService.scheduleAtTime(DateTime(startDay.year, startDay.month, startDay.day, startTime - 1, 45), notificationIdGeneratorWeekly(event), "Important Event",
            "${event.name} is coming up soon!");
//        DateTime curr = DateTime.now();
//        if (event.day > curr.weekday) {
//          DateTime future = curr.add(new Duration(days: event.day - curr.weekday)); // with days added to account for changes in month
//          print(future.weekday.toString() + " at day > curr.weekday");
//          print(future.day.toString() + " at day > curr.weekday");
//          print(future.month.toString() + " at day > curr.weekday");
////          print(s);
//          notificationService.scheduleAtTime(DateTime(future.year, future.month, future.day, startTime - 1, 45),
//              notificationIdGenerator(startTime, event.day), "Important Event", "${event.name} is coming up soon!");
//        } else if (curr.weekday == event.day) {
//          DateTime future = curr.add(new Duration(days: 7)); // with days added to account for changes in month
//          print(future.weekday.toString() + " at curr.weekday == day");
//          print(future.day.toString() + " at curr.weekday == day");
//          print(future.month.toString() + " at curr.weekday == day");
////          print(s);
//          curr.hour > startTime ? notificationService.scheduleAtTime(DateTime(future.year, future.month,
//              future.day, startTime - 1, 45), notificationIdGenerator(startTime, event.day), "Important Event", "${event.name} is coming up soon!")
//              :  notificationService.scheduleAtTime(DateTime(curr.year, curr.month,
//              curr.day, startTime - 1, 45), notificationIdGenerator(startTime, event.day), "Important Event", "${event.name} is coming up soon!");
//        } else {
//          DateTime future = curr.add(new Duration(days: event.day + 7 - curr.weekday)); // with days added to account for changes in month
//          print(future.weekday.toString() + " at curr.weekday < day");
//          print(future.day.toString() + " at curr.weekday < day");
//          print(future.month.toString() + " at curr.weekday < day");
//          notificationService.scheduleAtTime(DateTime(future.year, future.month, future.day, startTime - 1, 45),
//              notificationIdGenerator(startTime, event.day), "Important Event", "${event.name} is coming up soon!");
//        }
      }
    }
  }

  void delete(DateTime date, int startHour, int endHour) {
    DaySchedule ref = timetable[date];
    if (ref != null) {
      bool val = ref.deleteEvent(startHour, endHour);
      if (!val) {
        delete(date.add(Duration(days: -7)), startHour, endHour);
        delete(date.add(Duration(days: 7)), startHour, endHour);
      }
    }
    //FlutterLocalNotificationsPlugin().cancelAll();
  }

  Future<void> deleteWeeklyEvent(TimeTableEvent event) async {
    int s = event.timing.start;
//    print(day);
//    print(notificationIdGenerator(s, day));
    FlutterLocalNotificationsPlugin().cancelAll();
//    FlutterLocalNotificationsPlugin().cancel(
//        notificationIdGenerator(s, event.startDate.weekday));
    DateTime refDate = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
    while (refDate.isBefore(event.endDate)) {
      DaySchedule ref = timetable[refDate];
      if (ref != null) {
        delete(refDate, event.timing.start, event.timing.end);
        print('deleted');
        if (!ref.ds.any((val) => val != null)) {
          timetable.remove(refDate);
        }

      } else if (ref == null) {
        print('nothing is deleted');
      }
      refDate = refDate.add(Duration(days: 7));
    }
  }

  Future<void> deleteEvent(TimeTableEvent event) async {
    FlutterLocalNotificationsPlugin().cancelAll();
//    FlutterLocalNotificationsPlugin().cancel(
//        notificationIdGenerator(event.timing.start, event.startDate.weekday));
    DateTime index = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
    DaySchedule ref = timetable[index];
    ref.deleteEvent(event.timing.start, event.timing.end);
    timetable[index] = ref;
  }

  factory TimeTable.fromJson(Map<String, dynamic> data) => _$TimeTableFromJson(data);

  Map<String, dynamic> toJson() => _$TimeTableToJson(this);
}