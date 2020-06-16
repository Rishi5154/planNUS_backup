import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/schedule_time.dart';

part 'schedule_timing.g.dart';

@JsonSerializable(explicitToJson: true)
class ScheduleTiming {
  int start;
  int end;
  ScheduleTiming(int start) {
    this.start = start;
    this.end = start + 100;
  }

  static List<ScheduleTiming> allSlots = ScheduleTime.startTimeList
      .map((startTime) => ScheduleTiming(startTime.time)).toList();

  @override
  String toString() {
    String s = start < 1000 ? "0${start.toString()}" : start.toString();
    String e = end < 1000 ? "0${end.toString()}" : end.toString();
    return s + '-' + e;
  }

  factory ScheduleTiming.fromJson(Map<String, dynamic> data) => _$ScheduleTimingFromJson(data);

  Map<String, dynamic> toJson() => _$ScheduleTimingToJson(this);
}