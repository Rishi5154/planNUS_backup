// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    uid: json['uid'] as String,
  )
    ..timetable = json['timetable'] == null
        ? null
        : TimeTable.fromJson(json['timetable'] as Map<String, dynamic>)
    ..toDoDatabase = json['toDoDatabase'] == null
        ? null
        : TodoData.fromJson(json['toDoDatabase'] as Map<String, dynamic>)
    ..phoneNumber = json['phoneNumber'] as int
    ..schedule = json['schedule'] as bool
    ..initial = json['initial'] as bool;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'timetable': instance.timetable?.toJson(),
      'toDoDatabase': instance.toDoDatabase?.toJson(),
      'phoneNumber': instance.phoneNumber,
      'schedule': instance.schedule,
      'initial': instance.initial,
    };
