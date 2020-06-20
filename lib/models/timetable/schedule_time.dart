import 'package:json_annotation/json_annotation.dart';

part 'schedule_time.g.dart';

@JsonSerializable(explicitToJson: true)
class ScheduleTime {
  final int time;
  ScheduleTime({this.time});

  @override
  String toString() {
    return time < 1000
        ? "0" + time.toString()
        : time.toString();
  }

  static List<ScheduleTime> startTimeList = <ScheduleTime> [
    ScheduleTime(time: 0800), ScheduleTime(time: 0900), ScheduleTime(time: 1000), ScheduleTime(time: 1100),
    ScheduleTime(time: 1200), ScheduleTime(time: 1300), ScheduleTime(time: 1400), ScheduleTime(time: 1500),
    ScheduleTime(time: 1600), ScheduleTime(time: 1700), ScheduleTime(time: 1800), ScheduleTime(time: 1900),
  ];

  static List<ScheduleTime> endTimeList = <ScheduleTime> [
    ScheduleTime(time: 0900), ScheduleTime(time: 1000), ScheduleTime(time: 1100), ScheduleTime(time: 1200),
    ScheduleTime(time: 1300), ScheduleTime(time: 1400), ScheduleTime(time: 1500), ScheduleTime(time: 1600),
    ScheduleTime(time: 1700), ScheduleTime(time: 1800), ScheduleTime(time: 1900), ScheduleTime(time: 2000),
  ];

  factory ScheduleTime.fromJson(Map<String, dynamic> data) => _$ScheduleTimeFromJson(data);

  Map<String, dynamic> toJson() => _$ScheduleTimeToJson(this);
}