import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/timetable/timetable_event.dart';
import 'package:plannusandroidversion/models/timetable/weekly_event.dart';

part 'day_schedule.g.dart';

@JsonSerializable(explicitToJson: true)
class DaySchedule {
  List<TimeTableEvent> ds;

  DaySchedule(this.ds);

  static DaySchedule get noSchedule {
    return new DaySchedule([
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    ]);
  }
  static int _convert(int startTimeHour) {
    switch(startTimeHour) {
      case (8) : return 0;
      case (9) : return 1;
      case (10): return 2;
      case (11): return 3;
      case (12): return 4;
      case (13): return 5;
      case (14): return 6;
      case (15): return 7;
      case (16): return 8;
      case (17): return 9;
      case (18): return 10;
      case (19): return 11;
      default: return null;
     }
  }
  bool addable(WeeklyEvent event) {
    for (TimeTableEvent items in ds) {
      if (items != null && items.timing.coincide(event.timing)) {
        print('${event.name}  #####################EVENT IS NOT ADDABLE ############################');
        print('${items.name} coincides with ${event.name}');
        return false;
      }
    }
    return true;
  }

  void addEvent(TimeTableEvent event) {
    int index = _convert(event.timing.start);
    int duration = event.timing.end - event.timing.start;
    for (int i = index; i < index + duration; i++) {
      ds[i] = event;
    }
  }

  bool deleteEvent(int startHour, int endHour) {
    int index = _convert(startHour);
    int duration = endHour - startHour;
    bool tracker = true;
    for (int i = index; i < index + duration; i ++) {
      if (ds[i] != null) {
        tracker = false;
      }
      ds[i] = null;
    }
    return tracker;
  }

  factory DaySchedule.fromJson(Map<String, dynamic> data) => _$DayScheduleFromJson(data);

  Map<String, dynamic> toJson() => _$DayScheduleToJson(this);
}