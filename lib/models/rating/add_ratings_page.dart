import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:plannusandroidversion/models/timetable/day_schedule.dart';
import 'package:plannusandroidversion/models/timetable/timetable.dart';
import 'package:plannusandroidversion/models/timetable/timetable_event.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/services/database.dart';

class AddRatingsPage extends StatefulWidget {
  final User voter;
  final TimeTableEvent defaultSelection;
  AddRatingsPage({@required this.voter, this.defaultSelection});

  @override
  _AddRatingsPageState createState() => _AddRatingsPageState();
}

class _AddRatingsPageState extends State<AddRatingsPage> {
  static final TimeTableEvent _dummyEvent = TimeTableEvent(null, null, '----', false, null, null, null, null, null);

  //properties
  TimeTable tt;
  User voter;


  TimeTableEvent r;
  double rating;
  String review = '';
  String error = '';
  TextEditingController tec = TextEditingController();

  List<DropdownMenuItem<TimeTableEvent>> _buildRateableLists(TimeTable tt) {
    List<TimeTableEvent> currentEventList = new List<TimeTableEvent>();
    DateTime now = DateTime.now();
    DateTime ref = DateTime(now.year, now.month, now.day);
    ref = ref.add(Duration(days: -10));
    currentEventList.add(r);
    while (ref.isBefore(now)) {
      DaySchedule ds = tt.timetable[ref];
      if (ds != null) {
        for (TimeTableEvent e in ds.ds) {
          if (e != null) {
            if (!(currentEventList.any((event) => event.id == e.id))) {
              currentEventList.add(e);
            }
          }
        }
      }
      ref = ref.add(Duration(days: 1));
    }
    List<DropdownMenuItem<TimeTableEvent>> result = currentEventList.map((e) => DropdownMenuItem<TimeTableEvent>(
      value: e,
      child: Text(e.name),
    )).toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    this.voter = widget.voter;
    this.tt = voter.timetable;
    this.r = widget.defaultSelection ?? _dummyEvent;
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Event to rate:'),
                    SizedBox(width: 20),
                    DropdownButton<TimeTableEvent>(
//        TimeTableEvent(this.timing, this.id, this.name, this.isImportant, this.startDate, this.endDate, this.isWeekly, this.location);
                    value: r,
                    items: _buildRateableLists(tt),
                    onChanged: (val) {
                      setState(() {
                        r = val;
                      });
                    },
                    hint: Text('Select Event'),
                    ),
                  ],
                ),
                RatingBar(
                  allowHalfRating: true,
                  minRating: 0,
                  initialRating: 0,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.yellowAccent[400]
                  ),
                  onRatingUpdate: (val) {
                    setState((){
                      rating = val;
                    });
                  },
                ),
                Container(
                  width: 250.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Review'
                      ),
                      controller: tec,
                      onChanged: (str) {
                        setState(() {
                          review = str;
                        });
                      },
                      maxLines: 10,
                    ),
                  )
                ),
                RaisedButton(
                  color: Colors.grey[100],
                  child: Text('Submit'),
                  onPressed: () async {
                    if (r == _dummyEvent) {
                      setState(() {
                        error = 'Fill in Event to rate';
                      });
                    } else {
                      try {
                        await DatabaseMethods()
                            .addRatedEvent(r, rating, review, voter.name);
                        Navigator.pop(context);
                      } on AssertionError catch (e) {
                        setState((){
                          error = e.message.toString();
                        });
                      }
                    }
                  },
                ),
                Text(error, style: TextStyle(color: Colors.red, fontSize: 8.0))
              ]
          ),
        ),
      ),
    );
  }
}
