import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/timetable/schedule_timing.dart';

part 'meeting.g.dart';

@JsonSerializable(explicitToJson: true)
class Meeting {
  final String uid;
  final String name;
  String userUID;
  List<String> groupUID;
  ScheduleTiming slot;
  int day;
  bool isImportant;

  String requesterName;
  String memberNames;

  Meeting(this.uid, this.name, this.userUID, this.groupUID, this.requesterName, this.memberNames);

  void setDay(int day) { this.day = day; }

  void setSlot(ScheduleTiming slot) { this.slot = slot; }

  void setIsImportant(bool isImportant) { this.isImportant = isImportant; }

  factory Meeting.fromJson(Map<String, dynamic> data) => _$MeetingFromJson(data);

  Map<String, dynamic> toJson() => _$MeetingToJson(this);
}