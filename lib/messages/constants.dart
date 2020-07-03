import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:plannusandroidversion/models/timetable/schedule_timing.dart';
import 'package:plannusandroidversion/services/auth.dart';

import 'helperfunctions.dart';

class Constants {
  static String myName ="";
  static String myHandle ="";
  static Image myProfilePhoto;
  StorageReference reference;

  static final Offset zero = Offset.zero;

  static final List<int> allTimings = [0800, 0900, 1000, 1100, 1200, 1300,
    1400, 1500, 1600, 1700, 1800, 1900];

  static List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static List<int> weekdays = [1, 2, 3, 4, 5, 6, 7];

  static List<ScheduleTiming> visibleTiming = [
    ScheduleTiming(8,9),
    ScheduleTiming(9,10),
    ScheduleTiming(10,11),
    ScheduleTiming(11,12),
    ScheduleTiming(12,13),
    ScheduleTiming(13,14),
    ScheduleTiming(14,15),
    ScheduleTiming(15,16),
    ScheduleTiming(16,17),
    ScheduleTiming(17,18),
    ScheduleTiming(18,19),
    ScheduleTiming(19,20),
  ];

  static String stringDay(int day) {
    return days[day - 1];
  }

  // reset local cache
  static void resetAll() {
    Constants.myHandle = null;
    Constants.myName = null;
    Constants.myProfilePhoto = null;
  }

  // local cache setup - name, handle & profile photo
  static Future<void> setAll() async {
    Constants.myName = await HelperFunctions.getUsernameSharedPreferences();
    Constants.myHandle = await HelperFunctions.getUserHandleSharedPreferences();
    try {
      String url = await FirebaseStorage.instance.ref().child('${AuthService.currentUser.uid}/profileimage.jpg').getDownloadURL();
      Constants.myProfilePhoto = Image.network(url);
      print("Image loaded!");
      print(url);
    } catch (e) {
      print("Image loading failed!");
        Constants.myProfilePhoto = Image.asset('assets/profilepicture.png', height: 300, width: 300,);
    }
  }


}