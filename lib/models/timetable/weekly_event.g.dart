// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklyEvent _$WeeklyEventFromJson(Map<String, dynamic> json) {
  return WeeklyEvent(
    json['day'] as int,
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
    json['location'] as String,
    json['isPrivate'] as bool,
    json['type'] as String
  )..isWeekly = json['isWeekly'] as bool;
}

Map<String, dynamic> _$WeeklyEventToJson(WeeklyEvent instance) =>
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
      'day': instance.day,
      'type': instance.type
    };
