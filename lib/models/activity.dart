import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable(explicitToJson: true)
class Activity {
  static final nil = "No Activity";
  String name;
  bool isImportant;
  bool isFinish;
  Activity(this.name, this.isImportant, this.isFinish);

  static Activity customActivity(String name, bool isImportant, bool isFinish) {
    return new Activity(name, isImportant, isFinish);
  }

  static Activity noActivity() {
    return new Activity(nil, false, false);
  }

  void alter(String name) {
    this.name = name;
  }

  void deleteActivity() {
    this.name = nil;
    this.isImportant = false;
    this.isFinish = false;
  }

  void toggleImportant() {
    this.isImportant = true;
  }

  void toggleNotImportant() {
    this.isImportant = false;
  }

  factory Activity.fromJson(Map<String, dynamic> data) => _$ActivityFromJson(data);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}
// //continuation of Activity class
//  Widget dailyActivityTemplate() {
//    return DailyActivityCard(activity: this);
//  }
//
//  Widget weeklyActivityTemplate() {
//    return WeeklyActivityCard(activity: this);
//  }
//}
//
//class WeeklyActivityCard extends StatefulWidget {
//  final Activity activity;
//  WeeklyActivityCard({this.activity});
//  @override
//  WeeklyActivityCardState createState() => WeeklyActivityCardState();
//}
//
//class WeeklyActivityCardState extends State<WeeklyActivityCard> {
//  Activity a;
//
//  @override
//  Widget build(BuildContext context) {
//    a = widget.activity;
//    String name = a.data['name'];
//    bool isImportant = a.data['isImportant'];
//    bool isFinish = a.data['isFinish'];
//
//    return SizedBox(
//      width: 50.0,
//      height: 47.0,
//      child: Card(
//        color: name == 'No Activity'
//            ? Colors.grey[200] : isImportant
//            ? Colors.red : Colors.lightGreenAccent[100],
//        child: GestureDetector(
//          onTapDown: _storePosition,
//          child: Center(
//            child: Text(name,
//            style: TextStyle(
//              fontSize: 10,
//              color: Colors.black87,
//            ),
//            textAlign: TextAlign.center,
//            ),
//          ),
//          onLongPress: () {
//            _showPopupMenu();
//          },
//        ),
//      )
//    );
//  }
//
//  var _tapPosition;
//
//  _showPopupMenu() async {
//    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
//    await showMenu(
//      context: context,
//      position: RelativeRect.fromRect(
//          _tapPosition & Size(40, 40), // smaller rect, the touch area
//          Offset.zero & overlay.size // Bigger rect, the entire screen
//      ),
//      items: <PopupMenuEntry> [
//        PopupMenuItem<bool>(
//          value: true,
//          child: FlatButton(
//            child: Text("Delete"),
//            onPressed: () {setState(() {
//              a.deleteActivity();
//              Navigator.pop(context);
//            });},
//          ),
//        ),
//        PopupMenuItem<bool>(
//          value: false,
//          child: FlatButton(
//              child: Text("Cancel"),
//              onPressed: () {
//                Navigator.pop(context);
//              }
//          ),
//        )
//      ],
//      elevation: 8.0,
//    );
//  }
//  void _storePosition(TapDownDetails details) {
//    _tapPosition = details.globalPosition;
//  }
//
//}
//
//class DailyActivityCard extends StatefulWidget {
//  final Activity activity;
//  DailyActivityCard({ this.activity });
//
//  @override
//  DailyActivityState createState() {
//    return DailyActivityState();
//  }
//}
//
//class DailyActivityState extends State<DailyActivityCard> {
//  Activity a;
//
//  @override
//  Widget build(BuildContext context) {
//    a = widget.activity;
//    String name = a.data['name'];
//    String slot = a.data['slot'];
//    bool isImportant = a.data['isImportant'];
//    bool isFinish = a.data['isFinish'];
//    return Card(
//       margin: EdgeInsets.fromLTRB(16.0, 8, 16.0, 8),
//       child: Row(
//         children: <Widget> [
//           Container(
//             padding: EdgeInsets.all(20.0),
//             child: Text(
//                 slot,
//                 style: TextStyle(
//                   color: Colors.black87,
//                   fontSize: 17.5,
//                )
//             ),
//           ),
//          Expanded(
//            child: Container(
//              padding: EdgeInsets.all(20.0),
//              color: name == 'No Activity' ? Colors.grey[200] : isImportant ? Colors.red : Colors.lightGreenAccent[100],
//              child: GestureDetector(
//                onTapDown: _storePosition,
//                child: Text(
//                  name,
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.black87,
//                  ),
//                  textAlign: TextAlign.center,
//                ),
//                onLongPress: () {
//                  _showPopupMenu();
//                },
//              ),
//            ),
//          )
//         ],
//       ),
//      );
//  }
//
//  var _tapPosition;
//
//  _showPopupMenu() async {
//    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
//    await showMenu(
//      context: context,
//      position: RelativeRect.fromRect(
//          _tapPosition & Size(40, 40), // smaller rect, the touch area
//          Offset.zero & overlay.size // Bigger rect, the entire screen
//      ),
//      items: <PopupMenuEntry> [
//        PopupMenuItem<bool>(
//          value: true,
//          child: FlatButton(
//            child: Text("Delete"),
//            onPressed: () {setState(() {
//              a.deleteActivity();
//              Navigator.pop(context);
//            });},
//          ),
//        ),
//        PopupMenuItem<bool>(
//          value: false,
//          child: FlatButton(
//            child: Text("Cancel"),
//            onPressed: () {
//              Navigator.pop(context);
//            }
//          ),
//        )
//      ],
//      elevation: 8.0,
//    );
//  }
//  void _storePosition(TapDownDetails details) {
//    _tapPosition = details.globalPosition;
//  }
//}