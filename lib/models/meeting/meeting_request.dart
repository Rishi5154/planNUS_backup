import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/timetable/activity.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'meeting.dart';

part 'meeting_request.g.dart';

@JsonSerializable(explicitToJson: true)
class MeetingRequest {
  final String id;
  final Meeting meeting;
  int counter;
  bool isAccepted;

  MeetingRequest(this.id, this.meeting) {
    this.counter = 0;
    this.isAccepted = false;
  }

  void accept() async {
    this.counter++;
    isAccepted = (counter >= meeting.groupUID.length);
    if (isAccepted) {
      meeting.groupUID.forEach((uid) async {
        User user = await DatabaseMethods(uid: uid).getUserByUID(uid);
        user.deleteMeetingRequest(this);
        await user.addEvent(meeting.day, new Activity(meeting.name, true, false), meeting.slot);
      });
      await DatabaseMethods(uid: meeting.userUID)
          .getUserByUID(meeting.userUID)
          .then((user) => user.addEvent(meeting.day, new Activity(meeting.name, true, false), meeting.slot));
    }
  }

  void reject() {
    meeting.groupUID.forEach((uid) async {
      User user = await DatabaseMethods(uid: uid).getUserByUID(uid);
      await user.deleteMeetingRequest(this);
    });
  }

  factory MeetingRequest.fromJson(Map<String, dynamic> data) => _$MeetingRequestFromJson(data);

  Map<String, dynamic> toJson() => _$MeetingRequestToJson(this);
}