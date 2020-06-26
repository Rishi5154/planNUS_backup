import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/models/timetable/timetable.dart';
import 'package:plannusandroidversion/models/todo/todo_main.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo_data.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/models/timetable/weekly_event_adder.dart';
import 'package:plannusandroidversion/screens/drawer/notification_page.dart';
import 'package:plannusandroidversion/screens/drawer/user_search.dart';
import 'package:plannusandroidversion/screens/home/messages.dart';
import 'package:plannusandroidversion/screens/home/profile.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

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
              Text(
                Constants.myName == null || Constants.myName.isEmpty
                    ? 'Please update your name at Profile.'
                    : 'Please update your handle at Profile.',
                style: GoogleFonts.biryani(
                  fontSize: 16,
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
                backgroundColor: Colors.yellow, body: TimeTableWidget()
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
                  icon: Icon(Icons.add, color: Colors.white),
                  tooltip: 'Add',
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Provider<User>.value(value: user, child: WeeklyEventAdder()),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(35))
                          )
                        );
                      }
                    );
                  },
                ),
              ),
              TimerBuilder.periodic(
                Duration(seconds: 1),
                builder:(context) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 1.5),
                      height: 35,
                      width: 75,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Icon(Icons.access_time, size: 18,),
                          ),
                          Text("${getSystemTime()}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                        ],
                      ),
                    ),
                  );
                }),
              FlatButton.icon(
                  icon: Icon(Icons.person,
                    color: Colors.yellow,
                  ),
                  label: Text('logout',
                      style: TextStyle(color: Colors.yellow)
                  ),
                  onPressed: () async {
                    Constants.myName = null;
                    Constants.myHandle = null;
                    Constants.myProfilePhoto = null;
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
          drawer: Drawer(
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
                  padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
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
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
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
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
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
                title: Text('Home'),
                activeColor: Colors.red,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text('Timetable'),
                activeColor: Colors.purpleAccent,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.message),
                title: Text('Messages',
                ),
                activeColor: Colors.pink,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.perm_identity),
                title: Text('Profile'),
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
