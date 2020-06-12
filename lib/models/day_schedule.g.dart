// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DaySchedule _$DayScheduleFromJson(Map<String, dynamic> json) {
  return DaySchedule(
    json['day'] as int,
    (json['ds'] as List)
        ?.map((e) =>
            e == null ? null : Activity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DayScheduleToJson(DaySchedule instance) =>
    <String, dynamic>{
      'day': instance.day,
      'ds': instance.ds?.map((e) => e?.toJson())?.toList(),
    };
