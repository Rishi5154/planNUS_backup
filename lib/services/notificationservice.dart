import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationService {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  final FirebaseMessaging fcm = FirebaseMessaging();

  Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
    final pendingNotifications = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.dfa.plannusandroid' : 'com.duytq.flutterchatdemo',
      '',
      'Your timetable has been updated',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,

    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
    new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  Future<void> scheduleAtTime(DateTime time, int id, String title, String description) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'show weekly channel id',
      'show weekly channel name',
      'show weekly description',
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.schedule(
      id,
      title,
      description,
      time,
      platformChannelSpecifics,
    );
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