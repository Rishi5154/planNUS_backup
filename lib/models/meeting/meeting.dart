import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/user.dart';

part 'meeting.g.dart';

@JsonSerializable(explicitToJson: true)
class Meeting {
  String name;
  User requester;
  List<User> group;
  int day;
  int start; //scheduletiming
  int end;
  bool isImportant;

  Meeting(this.name, this.requester, this.group, this.day, this.start, this.end, this.isImportant);

  factory Meeting.fromJson(Map<String, dynamic> data) => _$MeetingFromJson(data);

  Map<String, dynamic> toJson() => _$MeetingToJson(this);
}