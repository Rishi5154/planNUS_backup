import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/models/timetable/timetable_widget.dart';
import 'package:plannusandroidversion/models/timetable/event_adder.dart';
import 'package:plannusandroidversion/models/todo/todo_main.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo_data.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/screens/drawer/my_drawer.dart';
import 'package:plannusandroidversion/screens/home/messages.dart';
import 'package:plannusandroidversion/screens/home/profile.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/shared/loading.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User user;
  var tabs = [];

  int currentIndex = 0;

  final AuthService auth = AuthService();

  String header = 'Home';

  setProfileDialog(BuildContext context) {
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (context) {
      return AlertDialog(
        title: Text(
          "Update essential profile details",
        ),
        content: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  Constants.myName == null || Constants.myName.isEmpty
                      ? 'Please update your name at Profile.'
                      : 'Please update your handle at Profile.',
                  style: GoogleFonts.biryani(
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            //color: Colors.deepPurple,
            onPressed: () {
              setState(() {
                currentIndex = 3;
              });
              Navigator.of(context).pop();
            },
            child: Text(
              'Noted!'
            ),
          )
        ],
      );
    });
  }

   getSystemTime() {
    //var now = new DateTime.now();
    String now = new DateFormat("HH:mm").format(new DateTime.now());
    //String now = DateFormat("H:mm").format(new );
    return now;
  }
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    if (user == null) {
      return Loading();
    } else {
      tabs = [
        MultiProvider(
          key: Key('Home'),
          providers: [
            StreamProvider<TodoData>.value(
              value: DatabaseMethods(uid: user.uid).getUserTodoDataStream(),
              catchError: (context, e) {return new TodoData();},
            ),
            StreamProvider<User>.value(
              value: DatabaseMethods(uid: user.uid).getUserStream2(),
            )
          ],
          child: Scaffold(backgroundColor: Colors.deepOrangeAccent[100],
              body: ToDoPage()
          ),
        ),
        //home
        Provider<User>.value(value: user,
            child: Scaffold(
                backgroundColor: Colors.yellow, body: TimeTableWidget(private: false,)
            )
        ),
        //TimeTable.emptyTimeTable()))),
        Provider<User>.value(value: user, child: Messages()),
        MultiProvider(providers: [
          StreamProvider<String>.value(
            value: DatabaseMethods(uid: user.uid).getHandleStream(),
            catchError: (context, e) { return "(no name yet)";}),
          ],
          child: Profile()),
      ];
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.deepPurple,
          appBar: AppBar(
            title: Text(header,
                style: TextStyle(
                  color: Colors.white,
                )),
            backgroundColor: Colors.black54,
            elevation: 0.0,
            actions: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 1.5),
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white, key: Key('Add timetable'),),
                  tooltip: 'Add',
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Provider<User>.value(value: user, child: EventAdder()),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(35))
                          )
                        );
                      }
                    );
                  },
                ),
              ),
//              TimerBuilder.periodic(
//                Duration(seconds: 1),
//                builder:(context) {
//                  return Center(
//                    child: Container(
//                      margin: EdgeInsets.only(top: 1.5),
//                      height: 35,
//                      width: 75,
//                      child: Row(
//                        children: <Widget>[
//                          Padding(
//                            padding: const EdgeInsets.only(left: 8.0, right: 8),
//                            child: Icon(Icons.access_time, size: 18,),
//                          ),
//                          Text("${getSystemTime()}",
//                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                  ),
//                        ],
//                      ),
//                    ),
//                  );
//                }),
              FlatButton.icon(
                  icon: Icon(Icons.person,
                    color: Colors.yellow,
                  ),
                  label: Text('logout',
                      style: TextStyle(color: Colors.yellow)
                  ),
                  onPressed: () async {
                    Constants.resetAll();
                    await auth.googleSignIn.isSignedIn().then((value) async {
                      if (value) {
                        AuthService.googleSignInAccount = null;
                        AuthService.googleUserId = null;
                        await auth.googleSignOut();
                      } else {
                        AuthService.currentUser = null;
                        await auth.signOut();
                      }
                    });
                  }
              )
            ],
          ),
          //********************DRAWER***********************//
          drawer: Provider<User>.value(
            value: user,
            child: MyDrawer(),
          ),
          body: tabs[currentIndex],
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: currentIndex,
            showElevation: true,
            itemCornerRadius: 8,
            curve: Curves.easeInBack,
            onItemSelected: (index) =>
              setState(() {
                print(index); //remove
                currentIndex = index;
                switch (index) {
                  case 0: { header = 'Home'; } break;
                  case 1: { header = 'Timetable'; } break;
                  case 2: { header = 'Messages'; } break;
                  case 3: { header = 'Profile'; } break;
                }
                if (currentIndex < 3) {
                  if (Constants.myName == null || Constants.myHandle == null) {
                    setProfileDialog(context);
                  } else if (Constants.myName.isEmpty || Constants.myHandle.isEmpty) {
                    setProfileDialog(context);
                  }
                }
//                if (currentIndex < 3  && Constants.myName == null || Constants.myHandle == null) {
//
//                }
//                if (currentIndex < 3 && Constants.myName.isEmpty || Constants.myHandle.isEmpty) {
//                  setProfileDialog(context);
//                } else if (Constants.myName == null || Constants.myHandle == null)
              }
            ),
            backgroundColor: Colors.white,
            items: [
              BottomNavyBarItem(
                icon: Icon(Icons.apps),
                title: Text('Home', style: GoogleFonts.openSans(),),
                activeColor: Colors.red,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.calendar_today, key: Key('Timetable-form'),),
                title: Text('Timetable', style: GoogleFonts.openSans() ),
                activeColor: Colors.purpleAccent,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.message),
                title: Text('Messages', style: GoogleFonts.openSans()
                ),
                activeColor: Colors.pink,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.perm_identity, key: Key('Profile-form'),),
                title: Text('Profile', style: GoogleFonts.openSans()),
                activeColor: Colors.blue,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}
