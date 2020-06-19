import 'package:json_annotation/json_annotation.dart';
import 'meeting.dart';

part 'meeting_request.g.dart';

@JsonSerializable(explicitToJson: true)
class MeetingRequest {
  final String id;
  final Meeting meeting;
  int counter;
  bool isAccepted;

  MeetingRequest(this.id, this.meeting) {
    this.counter = 1;
    this.isAccepted = false;
  }

  void accept() {
    this.counter++;
    isAccepted = (counter >= meeting.groupUID.length);
  }

  factory MeetingRequest.fromJson(Map<String, dynamic> data) => _$MeetingRequestFromJson(data);

  Map<String, dynamic> toJson() => _$MeetingRequestToJson(this);
}