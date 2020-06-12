// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeTable _$TimeTableFromJson(Map<String, dynamic> json) {
  return TimeTable(
    (json['timetable'] as List)
        ?.map((e) =>
            e == null ? null : DaySchedule.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TimeTableToJson(TimeTable instance) => <String, dynamic>{
      'timetable': instance.timetable?.map((e) => e?.toJson())?.toList(),
    };
