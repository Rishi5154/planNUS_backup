import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo_data.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/screens/authenticate/authenticate.dart';
import 'package:plannusandroidversion/screens/home/home.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // return either Home or Authenticate widget
    if (user == null) {
      print("################### User is null");
      return Authenticate();
    } else {
      print("################## User id :" + user.uid);
        return StreamProvider<User>.value(
            value: DatabaseMethods(uid: user.uid).getUserStream2(),
            child: StreamProvider<TodoData>.value(
              value: DatabaseMethods(uid: user.uid).getUserTodoDataStream(),
              child: Home(),
              catchError: (context, e) => new TodoData(),
            ),
          catchError: (context, e) {
              return user;
          },
        );
    }
  }
}