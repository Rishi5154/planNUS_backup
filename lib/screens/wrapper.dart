import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/screens/authenticate/authenticate.dart';
import 'package:plannusandroidversion/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);

    // return either Home or Authenticate widget
    return user == null ? Authenticate() : Home();
  }
}
