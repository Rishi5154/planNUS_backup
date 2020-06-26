import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plannusandroidversion/screens/home/home.dart';
import 'package:plannusandroidversion/screens/wrapper.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/services/notificationservice.dart';
import 'package:provider/provider.dart';
import 'package:plannusandroidversion/models/user.dart';

import 'package:time_machine/time_machine.dart';
import 'package:flutter/services.dart';

void main() async {
  //TEST-------------------------------------------
  WidgetsFlutterBinding.ensureInitialized();
  await TimeMachine.initialize({'rootBundle': rootBundle});
  //------------------------------------------------

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
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }
  @override
  void initState() {
    configLocalNotification();
    initialize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
        StreamProvider<QuerySnapshot>.value(value: DatabaseMethods().userList,)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.deepPurple,
          primaryColor: Colors.deepPurple,
        ),
        home: Wrapper()
      ),
    );
  }
}
