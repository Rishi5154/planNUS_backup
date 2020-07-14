import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plannusandroidversion/models/rating/rateable.dart';
import 'package:plannusandroidversion/models/rating/rating_page.dart';
import 'package:collection/collection.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/models/user_search.dart';
import 'package:plannusandroidversion/screens/drawer/notification_page.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  static final pad = const EdgeInsets.fromLTRB(8, 5, 8, 5);
  User user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.deepOrange,
                    Colors.orangeAccent,
                  ],
                    begin: Alignment.topLeft,
                    end: new Alignment(-1, -1),)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image(image: AssetImage('assets/planNUS.png'),height: 80, width: 40, ),
              )
          ),
          Padding(
            padding: pad,
            child: InkWell(
                splashColor: Colors.orange,
                onTap: () async {
                  QuerySnapshot _querySnapshot = Provider.of<QuerySnapshot>(context, listen: false);
                  if (_querySnapshot != null) {
                    showSearch(
                        context: context,
                        delegate: UserSearch(_querySnapshot, user)
                    );
                  } else {
                    await Future.delayed(Duration(seconds: 1))
                        .whenComplete(() => _querySnapshot = Provider.of<QuerySnapshot>(context, listen: false));
                    showSearch(
                        context: context,
                        delegate: UserSearch(_querySnapshot, user)
                    );
                  }
                },
                child: Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.people),
                      SizedBox(width: 20),
                      Text('Meet', style: TextStyle(fontSize: 20.0),)
                    ],
                  ),
                )
            ),
          ),
          Padding(
              padding: pad,
              child: InkWell(
                  splashColor: Colors.orange,
                  onTap: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child: StreamProvider<User>.value(
                              value: DatabaseMethods(uid: user.uid).getUserStream2(),
                              child: NotificationPage(currUser: user,),
                              catchError: (context, e) {
                                return user;
                              },
                            ),
                          );
                        });
                  },
                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.notifications),
                          SizedBox(width: 20),
                          Text('Notifications', style: TextStyle(fontSize: 20.0),),
                          SizedBox(width: 100),
                          Text(user.requests == null ? '0' : user.requests.length.toString() ,
                              style: TextStyle(fontSize: 20.0, color: Colors.red[800]))
                        ],
                      )
                  )
              )
          ),
          Padding(
            padding: pad,
            child: InkWell(
              splashColor: Colors.orange,
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return StreamProvider<QuerySnapshot>.value(
                      value: DatabaseMethods().getRateable(),
                      child: RatingPage(),
                      catchError: (context, e) => null,
                    );
                  }
                ));
              },
              child: Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.rate_review),
                    SizedBox(width: 20),
                    Text('Reviews', style: TextStyle(fontSize: 20.0))
                  ],
                )
              )
            ),
          ),
          Padding(
              padding: pad,
              child: InkWell(
                  splashColor: Colors.orange,
                  onTap: () {},
                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.settings),
                          SizedBox(width: 20),
                          Text('Settings', style: TextStyle(fontSize: 20.0),)
                        ],
                      )
                  )
              )
          ),
        ],
      ),
    );
  }
}
