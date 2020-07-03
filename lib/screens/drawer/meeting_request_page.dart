import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plannusandroidversion/models/meeting/meeting_handler.dart';
import 'package:plannusandroidversion/models/meeting/meeting_request.dart';
import 'package:plannusandroidversion/models/timetable/schedule_timing.dart';
import 'package:plannusandroidversion/models/meeting/meeting.dart';
import 'package:plannusandroidversion/services/database.dart';

class MeetingRequestPage extends StatefulWidget {
  final MeetingHandler meetingHandler;
  final bool atMessages;

  MeetingRequestPage(this.meetingHandler, this.atMessages);

  @override
  _MeetingRequestPageState createState() => _MeetingRequestPageState();
}

class _MeetingRequestPageState extends State<MeetingRequestPage> {
  MeetingHandler meetingHandler;
  Map<DateTime, List<ScheduleTiming>> freeTimings;
  static List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  Widget build(BuildContext context) {
    meetingHandler = widget.meetingHandler;
    freeTimings = meetingHandler.getFreeTiming();
    List<DateTime> oneMonthFromNow = [];
    DateTime refDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    for (int i = 0; i < 32; i ++) {
      oneMonthFromNow.add(refDate);
      refDate = refDate.add(Duration(days: 1));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: oneMonthFromNow.map(
                  (date) {
                    return _slotTile(date);
                  }
              ).toList()
            ),
          ),
        ]
      ),
    );
  }

  Widget _slotTile(DateTime date) {
    String dayName = days[date.weekday - 1] + ' ' + DateFormat.yMMMMd('en_US').format(date);
    List<ScheduleTiming> ref = freeTimings[date];
    if (ref != null && ref.isNotEmpty) {
      return Column(
        children: [
          Card(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
              child: Text(dayName),
            )
          ),
          Column(
            children: ref.map((slot) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  child: Text(slot.toString()),
                  onTap: () {
                    onTapDialog(context, date, slot);
                  },
                ),
              );
            }).toList()
          )
        ]
      );
    } else {
      return Container();
    }
  }

  onTapDialog(BuildContext context, DateTime date, ScheduleTiming slot) {
    TextEditingController _tec = new TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: Container(
            height: 200.0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 8.0),
                  child: Text('Meeting Request',
                  style: TextStyle(fontSize: 28.0),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                  child: TextField(
                    controller: _tec,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Purpose of Meeting',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Request'),
                      onPressed: () async {
                        //meeting that is not important (test)
                        String newMRID = Firestore.instance.collection('meetings').document().documentID;
                        Meeting meeting = Meeting(
                            newMRID,
                            _tec.text,
                            meetingHandler.requesterUID,
                            meetingHandler.memberUID,
                            meetingHandler.requesterName,
                            meetingHandler.memberNames);
                        meeting.setDate(date);
                        meeting.setSlot(slot);
                        meeting.setIsImportant(false); //TESTING ** SET ALL IMPORTANCE TO FALSE **
                        MeetingRequest mr = new MeetingRequest(newMRID, meeting);
                        Firestore.instance.collection('meetings').document(newMRID).setData({
                          'meeting': mr.toJson(),
                        });
                        meetingHandler.memberUID.forEach((uid) async {
                          await DatabaseMethods(uid: uid).addMeetingRequest(mr);
                        });
                        if (!widget.atMessages) {
                          await Future.delayed(Duration(milliseconds: 10))
                              .whenComplete(() => Navigator.pop(context))
                              .whenComplete(() => Navigator.pop(context))
                              .whenComplete(() => Navigator.pop(context));
                        } else {
                          await Future.delayed(Duration(milliseconds: 10))
                              .whenComplete(() => Navigator.pop(context))
                              .whenComplete(() => Navigator.pop(context));
                        }
                      },
                    ),
                    SizedBox(width: 30.0),
                    RaisedButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ],
            )
          )
        );
      }
    );
  }
}
