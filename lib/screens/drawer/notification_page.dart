import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';
import 'package:plannusandroidversion/models/meeting/custom_notification.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  User _currUser;
  List<CustomNotification> unreadNotifications;

  @override
  Widget build(BuildContext context) {
    _currUser = Provider.of<User>(context);
    unreadNotifications = _currUser.unread;
    List<CustomNotification> refUnread = unreadNotifications.reversed.toList();
    if(unreadNotifications.length > 0) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: ListView.builder(
                      itemCount: unreadNotifications.length,
                      itemBuilder: (context, index) {
                        CustomNotification not = refUnread[index];
                        String names = '';
                        if (not.info.group.length <= 5) {
                          not.info.group.forEach((user) =>
                          names + user.name + ", ");
                        } else {
                          List<User> refNames = not.info.group;
                          names = refNames[0].name + ", "
                              + refNames[1].name + ", "
                              + refNames[2].name + ", "
                              + refNames[3].name + "...";
                        }
                        names.substring(0, names.length - 2);
                        return Card(
                            child: Container(
                                child: Row(
                                    children: [
                                      Column(
                                          children: [
                                            Text(refUnread[index].info.name,
                                                style: TextStyle(fontSize: 15.0)),
                                            Text(names,
                                                style: TextStyle(fontSize: 10.0))
                                          ]
                                      ),
                                      FlatButton(
                                        child: Icon(Icons.check),
                                        onPressed: () {

                                        },
                                      ),
                                      FlatButton(
                                        child: Icon(Icons.clear),
                                        onPressed: () async {
                                          await _currUser.removeNotification(not);
                                        },
                                      ),
                                    ]
                                )
                            )
                        );
                      }
                  )
              ),
              Align(
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
    unreadNotifications = _currUser.unread;
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
