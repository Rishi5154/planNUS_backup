// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    uid: json['uid'] as String,
    name: json['name'] as String,
  )
    ..timetable = json['timetable'] == null
        ? null
        : TimeTable.fromJson(json['timetable'] as Map<String, dynamic>)
    ..phoneNumber = json['phoneNumber'] as int
    ..schedule = json['schedule'] as bool
    ..requests = (json['requests'] as List)
        ?.map((e) => e == null
            ? null
            : MeetingRequest.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'timetable': instance.timetable?.toJson(),
      'phoneNumber': instance.phoneNumber,
      'schedule': instance.schedule,
      'requests': instance.requests?.map((e) => e?.toJson())?.toList(),
    };
