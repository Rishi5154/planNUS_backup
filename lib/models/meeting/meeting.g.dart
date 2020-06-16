// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meeting _$MeetingFromJson(Map<String, dynamic> json) {
  return Meeting(
    json['name'] as String,
    json['requester'] == null
        ? null
        : User.fromJson(json['requester'] as Map<String, dynamic>),
    (json['group'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['day'] as int,
    json['start'] as int,
    json['end'] as int,
    json['isImportant'] as bool,
  );
}

Map<String, dynamic> _$MeetingToJson(Meeting instance) => <String, dynamic>{
      'name': instance.name,
      'requester': instance.requester?.toJson(),
      'group': instance.group?.map((e) => e?.toJson())?.toList(),
      'day': instance.day,
      'start': instance.start,
      'end': instance.end,
      'isImportant': instance.isImportant,
    };
