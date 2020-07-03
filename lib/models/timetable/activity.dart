import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/timetable/schedule_timing.dart';
import 'package:plannusandroidversion/models/timetable/timetable_event.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

part 'activity.g.dart';

///Activity that happens once on the date
@JsonSerializable(explicitToJson: true)
class Activity extends TimeTableEvent {
//  const BasicEvent({
//    @required Object id,
//    @required this.title,
//    @required this.color,
//    @required LocalDateTime start,
//    @required LocalDateTime end,
//  })
  //Constructor
  Activity(DateTime startDate, ScheduleTiming timing, String id, String name, bool isImportant)
      : super(timing, id, name, isImportant, startDate, startDate, false);

  ///startDate == endDate

  List<BasicEvent> get toBasicEvent {
    return [
      BasicEvent(
        id: id,
        title: name,
        color: isImportant ? Colors.redAccent : Colors.lightGreenAccent,
        start: LocalDateTime(startDate.year, startDate.month, startDate.day, timing.start, timing.start, 0),
        end: LocalDateTime(startDate.year, startDate.month, startDate.day, timing.end, timing.end, 0)
      )
    ];
  }

  //JsonSerializable methods
  factory Activity.fromJson(Map<String, dynamic> data) => _$ActivityFromJson(data);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}