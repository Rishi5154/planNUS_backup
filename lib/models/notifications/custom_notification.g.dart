// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomNotification _$CustomNotificationFromJson(Map<String, dynamic> json) {
  return CustomNotification(
    meetingRequest: json['meetingRequest'] == null
        ? null
        : MeetingRequest.fromJson(
            json['meetingRequest'] as Map<String, dynamic>),
    rateable: json['rateable'] == null
        ? null
        : TimeTableEvent.fromJson(json['rateable'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CustomNotificationToJson(CustomNotification instance) =>
    <String, dynamic>{
      'meetingRequest': instance.meetingRequest?.toJson(),
      'rateable': instance.rateable?.toJson(),
    };
