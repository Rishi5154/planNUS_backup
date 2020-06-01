// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeTable _$TimeTableFromJson(Map<String, dynamic> json) {
  return TimeTable(
    (json['timetable'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          (e as Map<String, dynamic>)?.map(
            (k, e) => MapEntry(k, e as Map<String, dynamic>),
          )),
    ),
  );
}

Map<String, dynamic> _$TimeTableToJson(TimeTable instance) => <String, dynamic>{
      'timetable': instance.timetable,
    };
