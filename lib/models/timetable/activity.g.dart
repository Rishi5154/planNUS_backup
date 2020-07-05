// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return Activity(
    json['startDate'] == null
        ? null
        : DateTime.parse(json['startDate'] as String),
    json['timing'] == null
        ? null
        : ScheduleTiming.fromJson(json['timing'] as Map<String, dynamic>),
    json['id'] as String,
    json['name'] as String,
    json['isImportant'] as bool,
    json['location'] == null ? null : json['location']
  )
    ..endDate = json['endDate'] == null
        ? null
        : DateTime.parse(json['endDate'] as String)
    ..isWeekly = json['isWeekly'] as bool;
}

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'timing': instance.timing?.toJson(),
      'id': instance.id,
      'name': instance.name,
      'isImportant': instance.isImportant,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isWeekly': instance.isWeekly,
      'location' : instance.location
    };
