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
    this.isAccepted = null;
  }
//  Activity(this.date, ScheduleTiming timing, String id, String name, bool isImportant)
  void accept() async {
    this.counter++;
    isAccepted = (counter >= meeting.groupUID.length) ? true : null;
    if (isAccepted) {
      meeting.groupUID.forEach((uid) async {
        User user = await DatabaseMethods(uid: uid).getUserByUID(uid);
        user.deleteMeetingRequest(this);
//        DateTime now = DateTime.now();
        await user.addActivity(new Activity(meeting.date, meeting.slot, id, meeting.name, meeting.isImportant));
      });
      User requester = await DatabaseMethods(uid: meeting.userUID).getUserByUID(meeting.userUID);
      await requester.addActivity(new Activity(meeting.date, meeting.slot, id, meeting.name, meeting.isImportant));
    }
  }

  void reject() {
    isAccepted = false;
    //Rishi you can do your listen
    meeting.groupUID.forEach((uid) async {
      User user = await DatabaseMethods(uid: uid).getUserByUID(uid);
      await user.deleteMeetingRequest(this);
    });
  }

  factory MeetingRequest.fromJson(Map<String, dynamic> data) => _$MeetingRequestFromJson(data);

  Map<String, dynamic> toJson() => _$MeetingRequestToJson(this);
}