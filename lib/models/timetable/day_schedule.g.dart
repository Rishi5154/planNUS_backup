// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DaySchedule _$DayScheduleFromJson(Map<String, dynamic> json) {
  return DaySchedule(
    (json['ds'] as List)
        ?.map((e) => e == null
            ? null
            : TimeTableEvent.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DayScheduleToJson(DaySchedule instance) =>
    <String, dynamic>{
      'ds': instance.ds?.map((e) => e?.toJson())?.toList(),
    };
