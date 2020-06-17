// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_timing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleTiming _$ScheduleTimingFromJson(Map<String, dynamic> json) {
  return ScheduleTiming(
    json['start'] as int,
  )..end = json['end'] as int;
}

Map<String, dynamic> _$ScheduleTimingToJson(ScheduleTiming instance) =>
    <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
    };
