import 'package:flutter/material.dart';
import 'package:plannusandroidversion/screens/wrapper.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:provider/provider.dart';
import 'models/todo/todo_models/database.dart';
import 'models/user.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child:
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: /*isUserLoggedIn != null ? (isUserLoggedIn ? Chatscreen() : */Wrapper()//)
        /* : Wrapper(),*/
      ),
    );
  }
}
