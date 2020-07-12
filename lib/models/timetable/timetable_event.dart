import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/models/timetable/activity.dart';
import 'package:plannusandroidversion/models/timetable/schedule_timing.dart';
import 'package:plannusandroidversion/models/timetable/weekly_event.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';

part 'timetable_event.g.dart';

/// An event that is shown on Timetable
@JsonSerializable(explicitToJson: true)
class TimeTableEvent {
  //Properties
  ScheduleTiming timing;
  String id;
  String name;
  bool isImportant;
  DateTime startDate;
  DateTime endDate;
  bool isWeekly;
  String location;

  //Constructor
  TimeTableEvent(this.timing, this.id, this.name, this.isImportant, this.startDate, this.endDate, this.isWeekly, this.location);

  //JsonSerializable methods
  factory TimeTableEvent.fromJson(Map<String, dynamic> data) => _$TimeTableEventFromJson(data);

  Map<String, dynamic> toJson() => _$TimeTableEventToJson(this);
}

class TimeTableEventWidget extends StatefulWidget {
  const TimeTableEventWidget(this.con, this.event, {Key key,})
      : assert(event != null), super(key: key);
  final event;
  final BuildContext con;
  @override
  _TimeTableEventWidgetState createState() => _TimeTableEventWidgetState();
}

class _TimeTableEventWidgetState extends State<TimeTableEventWidget> {

  var event;
  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }


  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    event = widget.event;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    return Material(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 0.75,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      color: event.isImportant ? Colors.redAccent : Colors.lightGreenAccent,
      child: GestureDetector(
        onTapDown: _storePosition,
        onLongPress: () async {
          showMenu(
            context: context,
            position: RelativeRect.fromRect(
                _tapPosition & Size(40, 40), // smaller rect, the touch area
                Constants.zero & overlay.size // Bigger rect, the entire screen
            ),
            items: <PopupMenuEntry> [
              PopupMenuItem<bool>(
                value: true,
                child: FlatButton(
                  child: Text("Delete"),
                  onPressed: () async {
                    setState(() {
                      if (event.isWeekly) {
                        user.timetable.deleteWeeklyEvent(event);
                      } else {
                        user.timetable.deleteEvent(event);
                      }
                    });
                    await user.update().whenComplete(() => Navigator.pop(widget.con));
                  },
                ),
              ),
              PopupMenuItem<bool>(
                value: false,
                child: FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(widget.con);
                    }
                ),
              )
            ],
            elevation: 8.0,
          );
        },
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              List<String> loc = event.location.split(' ');
              List<String> separated = List<String>();
              separated.add(loc[0]);
              int index = 0;
              for (int i = 1; i < loc.length; i++) {
                String token = loc[i];
                if ((separated[index] + ' $token').length < 30) {
                  separated[index] += ' $token';
                } else {
                  index ++;
                  separated.add(token);
                }
              }
              return SimpleDialog(
                title: Center(child:
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(event.name),
                      IconButton(
                        icon: Icon(Icons.close),
                        iconSize: 15.0,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ]
                )
                ),
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 10,
                    child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.location_on),
                                onPressed: () {

                                },
                              ),
                              Text(separated[0]),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: separated.length > 1
                                ? Column(
                                children: separated.getRange(1, separated.length).map((str) =>
                                    Row(children: [SizedBox(width: 47.0), Text(str)])
                                ).toList()
                            )
                                : Container(),
                          )
                        ]
                    ),
                  )
                ],
              );
            }
        );
      },
        child: Padding(
          padding: EdgeInsets.fromLTRB(4, 2, 4, 0),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            child: Text(event.name),
          ),
        ),
      ),
    );
  }
}