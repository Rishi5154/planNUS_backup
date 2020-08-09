import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/notifications/custom_notification.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  final User currUser;
  NotificationPage({this.currUser});
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  User _currUser;
  List<CustomNotification> unreadNotifications;

  setInitialNotifications() {
    setState(() {
      unreadNotifications = widget.currUser.requests;
    });
  }

  setNotifications(User u) async {
    setState(() {
      unreadNotifications = u.requests;
    });
  }

  @override
  void initState() {
    super.initState();
    setInitialNotifications();
  }

  @override
  Widget build(BuildContext context) {
    _currUser = Provider.of<User>(context);
    //unreadNotifications = _currUser.requests;
//    List<CustomNotification> refUnread = unreadNotifications.reversed.toList();
    if (unreadNotifications.length > 0) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 120,
                    child: ListView.builder(
                        itemCount: unreadNotifications.length,
                        itemBuilder: (context, index) {
                          return unreadNotifications[index].notificationWidget(_currUser, setNotifications, context);
                        }
                    ),
                  )
              ),
              Align(
                alignment: Alignment.bottomLeft,
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
