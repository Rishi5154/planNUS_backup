import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schedule_timing.g.dart';

@JsonSerializable(explicitToJson: true)
class  ScheduleTiming {
  //Properties
  int start; //hours
  int end;

  //Constructor
  ScheduleTiming(this.start, this.end);

  @override
  String toString() {
    String s = start < 10
        ? "0${start.toString()}00"
        : '${start.toString()}00' ;
    String e = end < 10
        ? "0${end.toString()}00"
        : '${end.toString()}00' ;
    return s + '-' + e;
  }

  bool coincide(ScheduleTiming other) {
    int thisStart = this.start;
    int thisEnd = this.end;
    int otherStart = other.start;
    int otherEnd = other.end;
    if (otherStart == thisStart || otherEnd == thisEnd) {
      return true;
    } else if (otherEnd > thisStart && otherEnd < thisEnd) {
      return true;
    } else if (otherStart > thisStart && otherStart < thisEnd) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool operator ==(dynamic other) =>
      super == other
          && start == other.start
          && end == other.end;

  @override
  int get hashCode => hashList([super.hashCode, start, end]);

  //JsonSerializable methods
  factory ScheduleTiming.fromJson(Map<String, dynamic> data) => _$ScheduleTimingFromJson(data);

  Map<String, dynamic> toJson() => _$ScheduleTimingToJson(this);
}