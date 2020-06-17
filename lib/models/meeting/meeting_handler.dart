import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/activity.dart';
import 'package:plannusandroidversion/models/meeting/custom_notification.dart';
import 'package:plannusandroidversion/models/schedule_time.dart';
import 'package:plannusandroidversion/models/user.dart';

import 'meeting.dart';

class MeetingHandler {
  final User user;
  final List<User> toCheck;
//  List<ScheduleTiming> slots = ScheduleTiming.allSlots;
  static List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  MeetingHandler(this.user, this.toCheck);

  String getMemberNames() {
    String result = '';
    if (toCheck.length > 5) {
      result += toCheck[0].name + ", ";
      result += toCheck[1].name + ", ";
      result += toCheck[2].name + ", ";
      result += toCheck[3].name + "...";
    } else {
      for (int i = 0; i < toCheck.length; i++) {
        if (i == toCheck.length - 1) {
          result += toCheck[0].name;
        } else {
          result += toCheck[0].name + ", ";
        }
      }
    }
    return result;
  }
  void addUserLists(List<User> list) {
    for(User u in list) {
      toCheck.add(u);
    }
  }

  void addUser(User u) {
    toCheck.add(u);
  }

  ScheduleTiming convertIntToST(int i) {
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
      List<Activity> ref = user.timetable.timetable[i].ds;
      print(user.name);
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
            addable.add(convertIntToST(j));
          }
        }
      }
      if (addable.isNotEmpty) {
        result[i + 1] = addable;
      }
    }
    return result;
  }

  Widget slotTile(int day, Map<int, List<ScheduleTiming>> freeTimings, BuildContext cont) {
    String dayName = days[day - 1];
    List<ScheduleTiming> ref = freeTimings[day];
    TextEditingController _tec = new TextEditingController();
    if (ref != null && ref.isNotEmpty) {
      return Column(
          children: [
            Card(color: Colors.blue, child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(dayName),
            )),
            Column(
                children: ref.map((slot) {
                  return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: InkWell(
                        child: Text(slot.toString()),
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: cont,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 110.0,
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: _tec,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Name of Meeting'
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              FlatButton(
                                                child: Text('Request'),
                                                onPressed: () async {
                                                  //meeting that is not important (test)
                                                  Meeting meeting = new Meeting(_tec.text, user, toCheck, day, slot.start, slot.end, false);
                                                  toCheck.forEach((u) async {
                                                    await u.addUnread(new CustomNotification(meeting, false));
                                                  });
                                                  await user.addUnread(new CustomNotification(meeting, false)).whenComplete(() => Navigator.pop(context));
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ]
                                          )
                                        ]
                                      ),
                                    )
                                  )
                                );
                              });
                        },
                      )
                  );
                }).toList()
            ),
          ]
      );
    } else {
      return Container();
    }
  }

  Widget showCommonFreeTiming(BuildContext context) {
    Map<int, List<ScheduleTiming>> freeTimings = getFreeTiming();
    List<int> days = [1,2,3,4,5,6,7];
    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
              children: days.map((day) => slotTile(day, freeTimings, context)).toList()
          )
      ),
    );
  }
}
