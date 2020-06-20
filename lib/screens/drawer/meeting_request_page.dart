import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/meeting/meeting_handler.dart';
import 'package:plannusandroidversion/models/meeting/meeting_request.dart';
import 'package:plannusandroidversion/models/timetable/schedule_timing.dart';
import 'package:plannusandroidversion/models/meeting/meeting.dart';
import 'package:plannusandroidversion/services/database.dart';

class MeetingRequestPage extends StatefulWidget {
  final MeetingHandler meetingHandler;

  MeetingRequestPage(this.meetingHandler);

  @override
  _MeetingRequestPageState createState() => _MeetingRequestPageState();
}

class _MeetingRequestPageState extends State<MeetingRequestPage> {
  MeetingHandler meetingHandler;
  Map<int, List<ScheduleTiming>> freeTimings;
  static List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  Widget build(BuildContext context) {
    meetingHandler = widget.meetingHandler;
    freeTimings = meetingHandler.getFreeTiming();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _slotTile(1),
                _slotTile(2),
                _slotTile(3),
                _slotTile(4),
                _slotTile(5),
                _slotTile(6),
                _slotTile(7),
              ]
            ),
          ),
        ]
      ),
    );
  }

  Widget _slotTile(int day) {
    String dayName = days[day - 1];
    List<ScheduleTiming> ref = freeTimings[day];
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
                    onTapDialog(context, day, slot);
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

  onTapDialog(BuildContext context, int day, ScheduleTiming slot) {
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
                        meeting.setDay(day);
                        meeting.setSlot(slot);
                        meeting.setIsImportant(false); //TESTING ** SET ALL IMPORTANCE TO FALSE **
                        MeetingRequest mr = new MeetingRequest(newMRID, meeting);
                        Firestore.instance.collection('meetings').document(newMRID).setData({
                          'meeting': mr.toJson(),
                        });
                        meetingHandler.memberUID.forEach((uid) async {
                          await DatabaseMethods(uid: uid).addMeetingRequest(mr);
                        });
//                        await DatabaseMethods(uid: meetingHandler.requesterUID).addMeetingRequest(mr)
//                        .whenComplete(() => Navigator.pop(context))
//                            .whenComplete(() => Navigator.pop(context))
//                            .whenComplete(() => Navigator.pop(context));
                          await Future.delayed(Duration(milliseconds: 10)).whenComplete(() => Navigator.pop(context))
                            .whenComplete(() => Navigator.pop(context))
                            .whenComplete(() => Navigator.pop(context));
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
