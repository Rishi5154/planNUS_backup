import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/meeting/meeting_request.dart';
import 'package:plannusandroidversion/models/notifications/custom_notification.dart';
import 'package:plannusandroidversion/models/rating/rateable.dart';
import 'package:plannusandroidversion/models/timetable/activity.dart';
import 'package:plannusandroidversion/models/timetable/day_schedule.dart';
import 'package:plannusandroidversion/models/timetable/timetable_event.dart';
import 'package:plannusandroidversion/models/timetable/weekly_event.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/models/timetable/timetable.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String uid;

  //User properties
  String name;
  TimeTable timetable;
  List<CustomNotification> requests;

  User({this.uid, this.name}) {
    timetable = TimeTable.emptyTimeTable();
    requests = new List<CustomNotification>();
  }

  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Future<void> changeName(String name) {
    this.name = name;
    return this.update();
  }

  Future<void> addMeetingRequest(MeetingRequest mr) {
    this.requests.add(CustomNotification.mrNotification(mr));
    return this.update();
  }

  Future<void> deleteMeetingRequest(MeetingRequest mr) {
    this.requests.removeWhere((req) => req.meetingRequest != null && req.meetingRequest.meeting.uid == mr.meeting.uid);
    return this.update();
  }

  Future<void> deleteReviewNotification(TimeTableEvent event) {
    this.requests.removeWhere((req) => req.rateable != null && req.rateable.id == event.id);
    return this.update();
  }

  Future<void> update() async {
    return DatabaseMethods(uid: this.uid).updateUserData2(this);
  }

  Future<void> addWeeklyEvent(WeeklyEvent activity) {
    this.timetable.addWeekly(activity);
    return this.update();
  }

  Future<void> addActivity(Activity activity) {
    DateTime refDate = DateTime(activity.startDate.year, activity.startDate.month, activity.startDate.day);
    DaySchedule ref = this.timetable.timetable[refDate] ?? DaySchedule.noSchedule;
    ref.addEvent(activity);
    this.timetable.timetable[refDate] = ref;
    return this.update();
  }

  Future<void> getReviewNotice() async {
    DateTime now = DateTime.now();
    List<Rateable> rateableList = await DatabaseMethods().getRateableList();
    DateTime refDate = DateTime(now.year, now.month, now.day);
    refDate = refDate.add(Duration(days: -7));
    List<TimeTableEvent> overdue = new List<TimeTableEvent>();
    while (refDate.isBefore(now)) {
      DaySchedule ref = this.timetable.timetable[refDate];
      if (ref != null) {
        for (TimeTableEvent event in ref.ds) {
          if (event != null && event.endDate.isBefore(now)) {
            if (overdue.every((e) => e.name != event.name)) {
              bool hasRated = await DatabaseMethods().checkRated(name, event.name);
              if (!hasRated) {overdue.add(event);}
            }
          }
        }
      }
      refDate = refDate.add(Duration(days: 1));
    }
    for (TimeTableEvent e in overdue) {
      if (rateableList.any((r) => r.event.id == e.id)) {
        if (rateableList.where((r) => r.event.id == e.id).first.reviews.containsKey(this.name)) {
          overdue.remove(e);
        }
      }
    }
    for (TimeTableEvent e in overdue) {
      requests.add(CustomNotification.reviewNotification(e));
    }
    return overdue.isNotEmpty ? this.update() : null;
  }
}