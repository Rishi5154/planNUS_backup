import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plannusandroidversion/screens/wrapper.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:plannusandroidversion/services/notificationservice.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  Future initialize() async {
    final NotificationService notificationService = new NotificationService();
    return await notificationService.initialise();
  }
  void configLocalNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  @override
  void initState() {
    // TODO: implement initState
    initialize();
    configLocalNotification();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child:
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Wrapper()
      ),
    );
  }
}
