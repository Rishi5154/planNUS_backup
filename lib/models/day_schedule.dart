import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/activity.dart';

part 'day_schedule.g.dart';

@JsonSerializable(explicitToJson: true)
class DaySchedule {
  static final List<int> allTimings = [0800, 0900, 1000, 1100, 1200, 1300,
                                       1400, 1500, 1600, 1700, 1800, 1900];

  static int getIndex(int startTime) {
    switch(startTime) {
      case(0800): return 0; break;
      case(0900): return 1; break;
      case(1000): return 2; break;
      case(1100): return 3; break;
      case(1200): return 4; break;
      case(1300): return 5; break;
      case(1400): return 6; break;
      case(1500): return 7; break;
      case(1600): return 8; break;
      case(1700): return 9; break;
      case(1800): return 10; break;
      case(1900): return 11; break;
      default: return 0; break;
    }
  }

  //properties of DaySchedule
  int day;
  List<Activity> ds;

  DaySchedule(this.day, this.ds);

  static DaySchedule noSchedule(int day) {
    return new DaySchedule(day, [
      Activity.noActivity(), //0800 - 0900
      Activity.noActivity(), //0900 - 1000
      Activity.noActivity(), // .
      Activity.noActivity(),
      Activity.noActivity(),
      Activity.noActivity(),
      Activity.noActivity(),
      Activity.noActivity(),
      Activity.noActivity(),
      Activity.noActivity(),
      Activity.noActivity(),
      Activity.noActivity(), //1900 - 2000, last activity of the day starts from 7pm and ends at 8pm
    ]);
  }

  void alter(int startTime, Activity activity) {
    int index = getIndex(startTime);
    ds[index] = activity;
  }

  Activity getActivity(int startTime) {
    int index = getIndex(startTime);
    return ds[index];
  }

  factory DaySchedule.fromJson(Map<String, dynamic> data) => _$DayScheduleFromJson(data);

  Map<String, dynamic> toJson() => _$DayScheduleToJson(this);
}