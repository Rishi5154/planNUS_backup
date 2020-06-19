import 'package:plannusandroidversion/models/activity.dart';
import 'package:plannusandroidversion/models/schedule_timing.dart';
import 'package:plannusandroidversion/models/user.dart';

class MeetingHandler {
  User requester;
  List<User> toCheck;

  MeetingHandler(this.requester, this.toCheck);

  ScheduleTiming _convertIntToST(int i) {
    switch(i) {
      case(0): return ScheduleTiming(800); break;
      case(1): return ScheduleTiming(900); break;
      case(2): return ScheduleTiming(1000); break;
      case(3): return ScheduleTiming(1100); break;
      case(4): return ScheduleTiming(1200); break;
      case(5): return ScheduleTiming(1300); break;
      case(6): return ScheduleTiming(1400); break;
      case(7): return ScheduleTiming(1500); break;
      case(8): return ScheduleTiming(1600); break;
      case(9): return ScheduleTiming(1700); break;
      case(10): return ScheduleTiming(1800); break;
      case(11): return ScheduleTiming(1900); break;
      default: return null; break;
    }
  }

  Map<int, List<ScheduleTiming>> getFreeTiming() {
    Map<int, List<ScheduleTiming>> result = new Map<int, List<ScheduleTiming>>();
    for (int i = 0; i < 6; i++) {
      List<Activity> ref = requester.timetable.timetable[i].ds;
      print(requester);
      print(requester.name);
      List<ScheduleTiming> addable = new List<ScheduleTiming>();
      for (int j = 0; j < 12; j++) {
        Activity ref2 = ref[j];
        if (ref2.name == Activity.nil) { //user is free
          print("check user is free on ${i.toString()} ${j.toString()}");
          bool track = true;
          for (User u in toCheck) {
            if (u.timetable.timetable[i].ds[j].name != Activity.nil) {
              track = false;
            }
          }
          if (track) {
            addable.add(_convertIntToST(j));
          }
        }
      }
      if (addable.isNotEmpty) {
        result[i + 1] = addable;
      }
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
      toCheck.forEach((user) =>
      names + user.name + ", ");
    } else {
      names = toCheck[0].name + ", "
          + toCheck[1].name + ", "
          + toCheck[2].name + ", "
          + toCheck[3].name + "...";
    }
  }
}