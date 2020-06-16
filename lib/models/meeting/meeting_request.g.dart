// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingRequest _$MeetingRequestFromJson(Map<String, dynamic> json) {
  return MeetingRequest(
    json['id'] as String,
    json['meeting'] == null
        ? null
        : Meeting.fromJson(json['meeting'] as Map<String, dynamic>),
  )
    ..counter = json['counter'] as int
    ..isAccepted = json['isAccepted'] as bool;
}

Map<String, dynamic> _$MeetingRequestToJson(MeetingRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meeting': instance.meeting?.toJson(),
      'counter': instance.counter,
      'isAccepted': instance.isAccepted,
    };
