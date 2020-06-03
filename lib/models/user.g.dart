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
    ..phoneNumber = json['phoneNumber'] as int
    ..schedule = json['schedule'] as bool;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'timetable': instance.timetable?.toJson(),
      'phoneNumber': instance.phoneNumber,
      'schedule': instance.schedule,
    };
