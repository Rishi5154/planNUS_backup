import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class WeeklyEvent extends Event {
  final String title;
  final int day;
  final bool isImportant;
  Color color;

  WeeklyEvent({
    @required Object id,
    @required this.title,
    @required this.day,
    @required this.isImportant,
    @required LocalDateTime start,
    @required LocalDateTime end,
  })  : assert(title != null),
        super(id: id, start: start, end: end);


  @override
  bool operator ==(dynamic other) =>
      super == other && title == other.title && isImportant == other.isImportant;

  @override
  int get hashCode => hashList([super.hashCode, title, isImportant]);
}


class WeeklyEventWidget extends StatefulWidget {
  const WeeklyEventWidget(this.event, {Key key,})
      : assert(event != null), super(key: key);

  final WeeklyEvent event;

  @override
  _WeeklyEventWidgetState createState() => _WeeklyEventWidgetState();
}

class _WeeklyEventWidgetState extends State<WeeklyEventWidget> {

  WeeklyEvent event;
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
      child: InkWell(
        onTapDown: _storePosition,
        onLongPress: () async {
          showMenu<bool>(
            position: _tapPosition,
            context: context,
            items: [
              PopupMenuItem<bool>(
                value: true,
                child: FlatButton(
                  child: Text("Delete"),
                  onPressed: () async {

                  },
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
          );
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(4, 2, 4, 0),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            child: Text(event.title),
          ),
        ),
      ),
    );
  }
}

