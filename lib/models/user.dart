import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/meeting/meeting_request.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'timetable.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String uid;

  //User properties
  String name;
  TimeTable timetable;
  List<MeetingRequest> requests;
  List<CustomNotification> unread;

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

  Future addMeetingRequest(MeetingRequest mr) {
    this.requests.add(mr);
    return this.update();
  }

  Future deletedMeetingRequest(MeetingRequest mr) {
    this.requests.removeWhere((req) => req.meeting.uid == mr.meeting.uid);
    return this.update();
  }

  Future<void> update() async {
    return DatabaseMethods(uid: this.uid).updateUserData2(this);
  }
}