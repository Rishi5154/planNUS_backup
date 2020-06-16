import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
class NotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging();

  Future initialise() async {
    if (Platform.isIOS) {
      fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    fcm.configure(
      // Invoked when app is in foreground
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        print("this has reached!");
    },
      // Invoked when app has been closed & notification has been opened
      onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch: $message');
      print("this has reached!");
    },
      // Invoked when app is in background & is opened from push
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        print("this has reached!");
      },
    );
  }
}