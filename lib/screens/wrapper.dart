import 'package:cloud_firestore/cloud_firestore.dart';
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
        return MultiProvider(
          providers: [
            StreamProvider<QuerySnapshot>.value(
                value: DatabaseMethods().userList, catchError: (context, e) => null
            ),
            StreamProvider<TodoData>.value
              (value: DatabaseMethods(uid: user.uid).getUserTodoDataStream(), catchError: (context, e) => new TodoData(),
            ),
            StreamProvider<User>.value(
              value: DatabaseMethods(uid: user.uid).getUserStream2(), catchError: (context, e) => new User(uid: user.uid),
            ),
          ],
          child: Home(),
        );
    }
  }
}