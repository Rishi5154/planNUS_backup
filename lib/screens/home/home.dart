import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/day_schedule.dart';
import 'package:plannusandroidversion/models/timetable.dart';
import 'package:plannusandroidversion/models/todo/pages/task_page.dart';
import 'package:plannusandroidversion/models/todo/todo_main.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/models/weekly_event_adder.dart';
import 'package:plannusandroidversion/screens/home/messages.dart';
import 'package:plannusandroidversion/screens/home/profile.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
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

  _HomeState() {
//    this.tabs = [
//      Scaffold(backgroundColor: Colors.deepOrangeAccent[100], body: ToDoApp()), //home
//      Scaffold(backgroundColor: Colors.yellow, body: TimeTableWidget(tt: user.timetable)),
//      Messages(),
//      Profile(),
//    ];
  }

  int currentIndex = 0;

  final AuthService auth = AuthService();

  String header = 'Home';

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    user.init();
    tabs = [
      Provider<User>.value(value: user, child: Scaffold(backgroundColor: Colors.deepOrangeAccent[100], body: ToDoApp())), //home
      Provider<User>.value(value: user, child: Scaffold(backgroundColor: Colors.yellow, body: TimeTableWidget(tt: user.timetable))),//TimeTable.emptyTimeTable()))),
      Provider<User>.value(value: user, child: Messages()),
      Provider<User>.value(value: user, child: Profile()),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
          },
        ),
        title: Text(header,
        style: TextStyle(
          color: Colors.white,
        )),
        backgroundColor: Colors.black54,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            tooltip: 'Add',
            onPressed: () async {
              List x = await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => WeeklyEventAdder()
              ));
              setState(() {
                user.timetable.alter(x[4], x[0], x[1], x[2], x[3]);
                print(user.timetable.timetable);
                tabs[0] = Scaffold(
                    backgroundColor: Colors.deepOrangeAccent[100],
                    body: TaskPage()//DayScheduleWidget(ds: user.timetable.timetable['Mon'])
                ); //home
                tabs[1] = Scaffold(
                    backgroundColor: Colors.yellow,
                    body: TimeTableWidget(tt: user.timetable)
                );
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          FlatButton.icon(
            icon: Icon(Icons.person,
            color: Colors.yellow,
            ),
            label: Text('logout',
              style: TextStyle(color: Colors.yellow)
            ),
              onPressed: () async {
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
        body: tabs[currentIndex],
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: currentIndex,
          showElevation: true,
          itemCornerRadius: 8,
          curve: Curves.easeInBack,
          onItemSelected: (index) => setState(() {
            print(index); //remove
            currentIndex = index;
            switch (index) {
              case 0: { header = 'Home'; }
              break;
              case 1: { header = 'Timetable'; }
              break;
              case 2: { header = 'Messages'; }
              break;
              case 3: { header = 'Profile'; }
              break;
            }
          }),
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
