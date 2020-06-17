import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/meeting/meeting_handler.dart';
import 'package:plannusandroidversion/models/meeting/meeting_request.dart';
import 'package:plannusandroidversion/models/schedule_timing.dart';
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
//          BackButton(
//            onPressed: () {
//              Navigator.pop(context);
//            },
//          )
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
                    onTapDialog(context);
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

  onTapDialog(BuildContext context) {
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
            height: 110.0,
            child: Column(
              children: [
                TextField(
                  controller: _tec,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Purpose of Meeting',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Request'),
                      onPressed: () async {
                        //meeting that is not important (test)
                        String newMRID = Firestore.instance.collection('meeting').document().documentID;
                        Meeting meeting = Meeting(
                            newMRID,
                            _tec.text,
                            meetingHandler.requesterUID,
                            meetingHandler.memberUID,
                            meetingHandler.requesterName,
                            meetingHandler.memberNames);
                        MeetingRequest mr = new MeetingRequest(newMRID, meeting);
                        Firestore.instance.collection('meeting').document(newMRID).updateData({
                          'meeting': mr.toJson(),
                        });
                        meetingHandler.memberUID.forEach((uid) async {
                          await DatabaseMethods(uid: uid).addMeetingRequest(mr);
                        });
                        await DatabaseMethods(uid: meetingHandler.requesterUID).addMeetingRequest(mr)
                        .whenComplete(() => Navigator.pop(context))
                            .whenComplete(() => Navigator.pop(context))
                            .whenComplete(() => Navigator.pop(context));
                      },
                    ),
                    FlatButton(
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
