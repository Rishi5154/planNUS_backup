import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/meeting/meeting_request.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  User _currUser;
  List<MeetingRequest> unreadNotifications;

  @override
  Widget build(BuildContext context) {
    _currUser = Provider.of<User>(context);
    unreadNotifications = _currUser.requests;
    List<MeetingRequest> refUnread = unreadNotifications.reversed.toList();
    if(unreadNotifications.length > 0) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: SizedBox(
                    height: 400.0,
                    child: ListView.builder(
                        itemCount: unreadNotifications.length,
                        itemBuilder: (context, index) {
                          MeetingRequest req = refUnread[index];
                          String name = req.meeting.name;
                          String requesterName = req.meeting.requesterName;
                          String memberNames = req.meeting.memberNames;
                          return Container(
                            height: 80,
                            child: Card(
                                child: Container(
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
                                                ]
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.check),
                                                  onPressed: () async {
                                                    MeetingRequest mr = await Firestore.instance.collection('meeting')
                                                        .document(req.id).get().then((val) => MeetingRequest.fromJson(val.data['meeting']));
                                                    mr.accept();
                                                    await Firestore.instance.collection('meeting').document(req.id).updateData({
                                                      'meeting' : mr.toJson()
                                                    });
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: () async {
                                                    await _currUser.deletedMeetingRequest(req);
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
                    ),
                  )
              ),
              Align(
                alignment: Alignment.topLeft,
                child: BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              )
            ],
          )
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 8.0),
              child: Container(
                child: Text('No notifications available')
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: BackButton(
                onPressed: () {
                    Navigator.pop(context);
                },
              )
            )
          ]
        ),
      );
    }
  }

  Widget notificationTile(BuildContext context) {
    _currUser = Provider.of<User>(context);
    unreadNotifications = _currUser.requests;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
      child: InkWell(
        splashColor: Colors.orange,
        onTap: () {},
        child: Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.notifications),
              SizedBox(width: 20),
              Text('Notifications', style: TextStyle(fontSize: 20.0),),
              SizedBox(width: 100),
              Text(unreadNotifications.length.toString(),
                style: TextStyle(
                  fontSize: 18.0,
                    color: Colors.red[800]
                )
              )
            ],
          )
        )
      )
    );
  }
}
