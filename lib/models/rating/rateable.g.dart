// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rateable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rateable _$RateableFromJson(Map<String, dynamic> json) {
  return Rateable(
    json['event'] == null
        ? null
        : TimeTableEvent.fromJson(json['event'] as Map<String, dynamic>),
    (json['currRating'] as num)?.toDouble(),
    json['votes'] as int,
    (json['reviews'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$RateableToJson(Rateable instance) => <String, dynamic>{
      'event': instance.event?.toJson(),
      'currRating': instance.currRating,
      'votes': instance.votes,
      'reviews': instance.reviews,
    };
