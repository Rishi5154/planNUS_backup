// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomNotification _$CustomNotificationFromJson(Map<String, dynamic> json) {
  return CustomNotification(
    json['info'] == null
        ? null
        : Meeting.fromJson(json['info'] as Map<String, dynamic>),
    json['isRead'] as bool,
  );
}

Map<String, dynamic> _$CustomNotificationToJson(CustomNotification instance) =>
    <String, dynamic>{
      'info': instance.info?.toJson(),
      'isRead': instance.isRead,
    };
