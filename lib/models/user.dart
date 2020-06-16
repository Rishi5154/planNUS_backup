import 'dart:collection';
import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/meeting/meeting_request.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'timetable.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String uid;
  String name;
  TimeTable timetable;
  int phoneNumber;
  bool schedule = false;
  List<MeetingRequest> requests;

  User({this.uid, this.name}) {
    timetable = TimeTable.emptyTimeTable();
    requests = new List<MeetingRequest>();
  }

  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Future<void> changeName(String name) async {
    if (this.name == null) {
      this.name = name;
      return this.update();
    } else {
       return null;
    }
  }

  Future addPhoneNumber(int number) async {
    this.phoneNumber = number;
    return await update();
  }

  Future<void> update() async {
    return DatabaseMethods(uid: this.uid).updateUserData2(this);
  }

  Future addMeetingRequest(MeetingRequest mr) {
    this.requests.add(mr);
    return this.update();
  }

  Future deletedMeetingRequest(MeetingRequest mr) {
    this.requests.removeWhere((req) => req.meeting.uid == mr.meeting.uid);
    return this.update();
  }
}