import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/meeting/meeting.dart';
import 'package:plannusandroidversion/models/meeting/meeting_request.dart';
import 'package:plannusandroidversion/models/rating/add_ratings_page.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/models/timetable/timetable_event.dart';
import 'package:plannusandroidversion/models/user.dart';

part 'custom_notification.g.dart';

///Could not make this abstract because JsonSerializable cannot be abstract class.
@JsonSerializable(explicitToJson: true)
class CustomNotification {
  MeetingRequest meetingRequest;
  TimeTableEvent rateable;

  CustomNotification({this.meetingRequest, this.rateable});

  static CustomNotification mrNotification(MeetingRequest mr) {
    return new CustomNotification(meetingRequest: mr);
  }

  static CustomNotification reviewNotification(TimeTableEvent event) {
    return new CustomNotification(rateable: event);
  }

  Widget notificationWidget(User user, Function(User) func, BuildContext con) {
    if (meetingRequest != null && rateable == null) {
      return _meetingRequestNotificationWidget(user, func);
    } else if (meetingRequest == null && rateable != null){
      return _reviewNotificationWidget(user, con);
    } else { //Error widget
      return Container(
        child: Text('Error, this is not mrNotification nor reviewNotification', style: TextStyle(color: Colors.red, fontSize: 20),)
      );
    }
  }

  Widget _meetingRequestNotificationWidget(User user, Function(User) func) {
    Meeting reqMeeting = meetingRequest.meeting;
    String name = reqMeeting.name;
    String requesterName = reqMeeting.requesterName;
    String memberNames = reqMeeting.memberNames;
    String stringDay = Constants.stringDay(reqMeeting.date.weekday) + " " + DateFormat.yMMMMd('en_US').format(reqMeeting.date);
    String stringSlot = reqMeeting.slot.toString();
    return Container(
      height: 80,
      child: Card(
          child: Container(
              height: 100,
              child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                          children: [
                            Text(name,
                                style: TextStyle(fontSize: 24.0)
                            ),
                            Text('Requested by: $requesterName',
                                style: TextStyle(fontSize: 12.0)
                            ),
                            Text('Members: $memberNames',
                                style: TextStyle(fontSize: 12.0)
                            ),
                            Text('$stringDay, $stringSlot',
                                style: TextStyle(fontSize: 10.0, color: Colors.red)
                            )
                          ]
                      ),
                    ),
                    Expanded(
                        child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.check),
                                onPressed: () async {
                                  MeetingRequest mr = await Firestore.instance.collection("meetings")
                                      .document(meetingRequest.id).get().then((val) => MeetingRequest.fromJson(val.data['meeting']));
                                  mr.accept();
                                  await Firestore.instance.collection("meetings").document(meetingRequest.id).updateData({
                                    'meeting' : mr.toJson()
                                  });
                                  await user.deleteMeetingRequest(mr);
                                  func(user);

                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () async {
                                  await user.deleteMeetingRequest(meetingRequest);
                                  func(user);
                                },
                              ),
                            ]
                        )
                    ),
                  ]
              )
          )
      ),
    );
  }

  Widget _reviewNotificationWidget(User voter, BuildContext context) {
    return Container(
      height: 80.0,
      child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('Review ${rateable.name}',
                  style: TextStyle(fontSize: 20.0)
              ),
            ),
            Expanded(
                child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AddRatingsPage(voter: voter, defaultSelection: rateable);
                              }
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () async {

                        },
                      ),
                    ]
                )
            ),
          ]
      ),
    );
  }

  factory CustomNotification.fromJson(Map<String, dynamic> data) => _$CustomNotificationFromJson(data);

  Map<String, dynamic> toJson() => _$CustomNotificationToJson(this);
}