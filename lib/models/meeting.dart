import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/schedule_time.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';
import 'package:plannusandroidversion/models/timetable.dart';

class Meeting {
  final User user;
  List<User> toCheck;
  List<ScheduleTiming> slots = ScheduleTiming.allSlots;

  Meeting(this.user) {
    toCheck = new List<User>();
  }

  void addUserLists(List<User> list) {
    for(User u in list) {
      toCheck.add(u);
    }
  }

  void addUser(User u) {
    toCheck.add(u);
  }

  Map<String, ScheduleTiming> getFreeTiming() {
    Map<String, ScheduleTiming> result = new Map<String, ScheduleTiming>();
    for (User u in toCheck) {

    }
    return result;
  }

  Widget searchList() {
    
  }
}