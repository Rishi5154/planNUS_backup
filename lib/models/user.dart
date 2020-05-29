import 'package:plannusandroidversion/models/todo/todo_models/database.dart';

import 'timetable.dart';

class User {
  final String uid;
  TimeTable timetable = TimeTable.emptyTimeTable();
  TodoDatabase toDoDatabase = TodoDatabase();
  int phoneNumber;
  bool schedule = false;
  bool initial = true;

  User({this.uid});

  void init() {
    if (initial) {
      timetable = TimeTable.emptyTimeTable();
      initial = false;
    }
  }
}

class UserData {
   String uid;
   String name;
   String handle;
   UserData({this.name, this.handle});
}
