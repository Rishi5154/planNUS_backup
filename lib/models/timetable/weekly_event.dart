import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/timetable/schedule_timing.dart';
import 'package:plannusandroidversion/models/timetable/timetable_event.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

part 'weekly_event.g.dart';

@JsonSerializable(explicitToJson: true)
class WeeklyEvent extends TimeTableEvent {
  //Properties
  int day;
  
  //Constructor
  WeeklyEvent(this.day,
      ScheduleTiming timing, String id, String name,
      bool isImportant, DateTime startDate, DateTime endDate,
      String location, bool isPrivate)
      : super(timing, id, name, isImportant, startDate,
      endDate, true, location, isPrivate);

  List<BasicEvent> get toBasicEvents {
    DateTime ref = startDate;
    if (ref.weekday != day) {
      ref = ref.add(Duration(days: 7 + day - ref.weekday));
    }
    List<BasicEvent> result = new List<BasicEvent>();
    while (ref.isBefore(endDate)) {
      result.add(new BasicEvent(
        id: id,
        title: name,
        color: isImportant ? Colors.redAccent : Colors.lightGreenAccent,
        start: LocalDateTime(ref.year, ref.month, ref.day, timing.start, 0, 0),
        end: LocalDateTime(ref.year, ref.month, ref.day, timing.end, 0, 0),
      ));
      ref = ref.add(Duration(days: 7));
    }
    return result;
  }
  
  //JsonSerializable methods
  factory WeeklyEvent.fromJson(Map<String, dynamic> data) => _$WeeklyEventFromJson(data);

  Map<String, dynamic> toJson() => _$WeeklyEventToJson(this);
}