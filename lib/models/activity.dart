import 'package:flutter/material.dart';
import 'schedule_time.dart';

class Activity {
  static final nil = "No Activity";

  String name;
  ScheduleTiming slot;
  bool isImportant = false;
  bool isFinish = false;

  Activity(String name, ScheduleTiming slot) {
    this.name = name;
    this.slot = slot;
  }

  static Activity noActivity(ScheduleTiming slot) {
    return new Activity(nil, slot);
  }

  void alter(String name) {
    this.name = name;
  }

  void deleteActivity() {
    this.name = nil;
    isImportant = false;
  }

  void toggleImportant() {
    this.isImportant = true;
  }

  void toggleNotImportant() {
    this.isImportant = false;
  }

  Widget dailyActivityTemplate() {
    return DailyActivityCard(activity: this);
  }

  Widget weeklyActivityTemplate() {
    return WeeklyActivityCard(activity: this);
  }
}

class WeeklyActivityCard extends StatefulWidget {
  final Activity activity;
  WeeklyActivityCard({this.activity});
  @override
  WeeklyActivityCardState createState() => WeeklyActivityCardState(a: this.activity);
}

class WeeklyActivityCardState extends State<WeeklyActivityCard> {
  Activity a;
  WeeklyActivityCardState({this.a});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.0,
      height: 47.0,
      child: Card(
        color: a.name == 'No Activity'
            ? Colors.grey[200] : a.isImportant
            ? Colors.red : Colors.lightGreenAccent[100],
        child: GestureDetector(
          onTapDown: _storePosition,
          child: Center(
            child: Text(a.name,
            style: TextStyle(
              fontSize: 10,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            ),
          ),
          onLongPress: () {
            _showPopupMenu();
          },
        ),
      )
    );
  }

  var _tapPosition;

  _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
      ),
      items: <PopupMenuEntry> [
        PopupMenuItem<bool>(
          value: true,
          child: FlatButton(
            child: Text("Delete"),
            onPressed: () {setState(() {
              a.deleteActivity();
              Navigator.pop(context);
            });},
          ),
        ),
        PopupMenuItem<bool>(
          value: false,
          child: FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
        )
      ],
      elevation: 8.0,
    );
  }
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

}



class DailyActivityCard extends StatefulWidget {
  final Activity activity;
  DailyActivityCard({ this.activity });

  @override
  DailyActivityState createState() {
    // TODO: implement createState
    return DailyActivityState(this.activity);
  }
}

class DailyActivityState extends State<DailyActivityCard> {
  Activity a;
  DailyActivityState(Activity a) { this.a = a;}



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
       margin: EdgeInsets.fromLTRB(16.0, 8, 16.0, 8),
       child: Row(
         children: <Widget> [
           Container(
             padding: EdgeInsets.all(20.0),
             child: Text(
                 a.slot.toString(),
                 style: TextStyle(
                   color: Colors.black87,
                   fontSize: 17.5,
                )
             ),
           ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: a.name == 'No Activity' ? Colors.grey[200] : a.isImportant ? Colors.red : Colors.lightGreenAccent[100],
              child: GestureDetector(
                onTapDown: _storePosition,
                child: Text(
                  a.name,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                onLongPress: () {
                  _showPopupMenu();
                },
              ),
            ),
          )
         ],
       ),
      );
  }

  var _tapPosition;

  _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
      ),
      items: <PopupMenuEntry> [
        PopupMenuItem<bool>(
          value: true,
          child: FlatButton(
            child: Text("Delete"),
            onPressed: () {setState(() {
              a.deleteActivity();
              Navigator.pop(context);
            });},
          ),
        ),
        PopupMenuItem<bool>(
          value: false,
          child: FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
        )
      ],
      elevation: 8.0,
    );
  }
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }
}