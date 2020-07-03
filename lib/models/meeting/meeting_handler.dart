import 'package:plannusandroidversion/models/timetable/activity.dart';
import 'package:plannusandroidversion/models/timetable/day_schedule.dart';
import 'package:plannusandroidversion/models/timetable/schedule_timing.dart';
import 'package:plannusandroidversion/models/timetable/timetable_event.dart';
import 'package:plannusandroidversion/models/user.dart';

class MeetingHandler {
  User requester;
  List<User> toCheck;

  MeetingHandler(this.requester, this.toCheck);

  ScheduleTiming _convertIntToST(int i) {
    switch(i) {
      case(0): return ScheduleTiming(8,9); break;
      case(1): return ScheduleTiming(9,10); break;
      case(2): return ScheduleTiming(10,11); break;
      case(3): return ScheduleTiming(11,12); break;
      case(4): return ScheduleTiming(12,13); break;
      case(5): return ScheduleTiming(13,14); break;
      case(6): return ScheduleTiming(14,15); break;
      case(7): return ScheduleTiming(15,16); break;
      case(8): return ScheduleTiming(16,17); break;
      case(9): return ScheduleTiming(17,18); break;
      case(10): return ScheduleTiming(18,19); break;
      case(11): return ScheduleTiming(19,20); break;
      default: return null; break;
    }
  }
  //Two weeks ahead
  Map<DateTime, List<ScheduleTiming>> getFreeTiming() {
    Map<DateTime, List<ScheduleTiming>> result = new Map<DateTime, List<ScheduleTiming>>();
    DateTime refDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    for (int i = 0; i < 15; i ++) {
      List<TimeTableEvent> ref = requester.timetable.timetable[refDate] == null
          ? DaySchedule.noSchedule.ds
          : requester.timetable.timetable[refDate].ds;
//      print(requester);
//      print(requester.name);
      List<ScheduleTiming> addable = new List<ScheduleTiming>();
      for (int j = 0; j < 12; j++) {
        TimeTableEvent ref2 = ref[j];
        if (ref2 == null) { //user is free
          print("check user is free on ${i.toString()} ${j.toString()}");
          bool track = true;
          for (User u in toCheck) {
            List<TimeTableEvent> uRef = u.timetable.timetable[refDate] == null
                ? DaySchedule.noSchedule.ds
                : u.timetable.timetable[refDate].ds;
            if (uRef[j] != null) {
              track = false;
            }
          }
          if (track) {
            addable.add(_convertIntToST(j));
          }
        }
      }
      if (addable.isNotEmpty) {
        result[refDate] = addable;
      }
      refDate = refDate.add(Duration(days: 1));
    }
    return result;
  }

  get memberUID {
    List<String> result = new List<String>();
    toCheck.forEach((user) => result.add(user.uid));
    return result;
  }

  get requesterUID {
    return requester.uid;
  }

  get requesterName {
    return requester.name;
  }

  get memberNames {
    String names = '';
    if (toCheck.length <= 5) {
      toCheck.forEach((user) => (names =
      names + user.name + ", "));
      names = names.substring(0, names.length - 2);
    } else {
      names = toCheck[0].name + ", "
          + toCheck[1].name + ", "
          + toCheck[2].name + ", "
          + toCheck[3].name + "...";
    }
    return names;
  }
}