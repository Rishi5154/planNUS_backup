// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeTableEvent _$TimeTableEventFromJson(Map<String, dynamic> json) {
  return TimeTableEvent(
    json['timing'] == null
        ? null
        : ScheduleTiming.fromJson(json['timing'] as Map<String, dynamic>),
    json['id'] as String,
    json['name'] as String,
    json['isImportant'] as bool,
    json['startDate'] == null
        ? null
        : DateTime.parse(json['startDate'] as String),
    json['endDate'] == null ? null : DateTime.parse(json['endDate'] as String),
    json['isWeekly'] as bool,
    json['location'] as String,
    json['isPrivate'] as bool,
    json['type'] as String
  );
}

Map<String, dynamic> _$TimeTableEventToJson(TimeTableEvent instance) =>
    <String, dynamic>{
      'timing': instance.timing?.toJson(),
      'id': instance.id,
      'name': instance.name,
      'isImportant': instance.isImportant,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isWeekly': instance.isWeekly,
      'location': instance.location,
      'isPrivate': instance.isPrivate,
      'type': instance.type
    };
