import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/meeting/meeting_request.dart';
import 'package:plannusandroidversion/models/timetable/activity.dart';
import 'package:plannusandroidversion/models/timetable/day_schedule.dart';
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
  List<MeetingRequest> requests;

  User({this.uid, this.name}) {
    timetable = TimeTable.emptyTimeTable();
    requests = new List<MeetingRequest>();
  }

  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Future<void> changeName(String name) {
    this.name = name;
    return this.update();
  }

  Future<void> addMeetingRequest(MeetingRequest mr) {
    this.requests.add(mr);
    return this.update();
  }

  Future<void> deleteMeetingRequest(MeetingRequest mr) {
    this.requests.removeWhere((req) => req.meeting.uid == mr.meeting.uid);
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
}