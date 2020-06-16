// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meeting _$MeetingFromJson(Map<String, dynamic> json) {
  return Meeting(
    json['uid'] as String,
    json['name'] as String,
    json['userUID'] as String,
    (json['groupUID'] as List)?.map((e) => e as String)?.toList(),
    json['requesterName'] as String,
    json['memberNames'] as String,
  )
    ..slot = json['slot'] == null
        ? null
        : ScheduleTiming.fromJson(json['slot'] as Map<String, dynamic>)
    ..day = json['day'] as int
    ..isImportant = json['isImportant'] as bool;
}

Map<String, dynamic> _$MeetingToJson(Meeting instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'userUID': instance.userUID,
      'groupUID': instance.groupUID,
      'slot': instance.slot?.toJson(),
      'day': instance.day,
      'isImportant': instance.isImportant,
      'requesterName': instance.requesterName,
      'memberNames': instance.memberNames,
    };
