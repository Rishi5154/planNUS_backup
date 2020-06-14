import 'package:json_annotation/json_annotation.dart';
import 'meeting.dart';

part 'custom_notification.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomNotification {
  Meeting info;
  bool isRead;

  CustomNotification(this.info, this.isRead);

  factory CustomNotification.fromJson(Map<String, dynamic> data) => _$CustomNotificationFromJson(data);

  Map<String, dynamic> toJson() => _$CustomNotificationToJson(this);
}