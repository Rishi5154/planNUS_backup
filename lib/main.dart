import 'package:flutter/material.dart';
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

  Future initialize() async {
    final NotificationService notificationService = new NotificationService();
    return await notificationService.initialise();
  }
  @override
  void initState() {
    // TODO: implement initState
    initialize();
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
