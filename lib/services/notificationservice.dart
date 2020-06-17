import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationService {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  final FirebaseMessaging fcm = FirebaseMessaging();

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.dfa.plannusandroid' : 'com.duytq.flutterchatdemo',
      '',
      'Your timetable has been updated',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
    new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }


  Future initialise() async {
    if (Platform.isIOS) {
      fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    fcm.configure(
      // Invoked when app is in foreground
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        print("this has reached! at onMessage");
        if (Platform.isAndroid) {
          showNotification(message['notification']);
        }
    },
      // Invoked when app has been closed & notification has been opened
      onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch: $message');
      print("this has reached! at onLanunch");
      if (Platform.isAndroid) {
        showNotification(message['notification']);
      }
    },
      // Invoked when app is in background & is opened from push
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        print("this has reached! at onResume");
        if (Platform.isAndroid) {
          showNotification(message['notification']);
        }
      },
    );
  }
}