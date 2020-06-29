import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plannusandroidversion/messages/chats.dart';
import 'package:plannusandroidversion/messages/chatscreenredirect.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/models/meeting/meeting_handler.dart';
import 'package:plannusandroidversion/models/meeting/meeting_request.dart';
import 'package:plannusandroidversion/models/timetable/timetable.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/screens/drawer/meeting_request_page.dart';
import 'package:plannusandroidversion/models/user_search.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/messages/helperfunctions.dart';
import 'package:plannusandroidversion/services/notificationservice.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

//  AuthService auth = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;
  User user;
  QuerySnapshot ss;

  // method to load the curr user's chat history
  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  StreamProvider<User>.value(
                    //stream: databaseMethods.getUserStreamByUid(snapshot.data.documents[index].data['uidOther']),
                    value: databaseMethods.getUserStreamByUid(user.uid == snapshot.data.documents[index].data['uidOther']
                        ? snapshot.data.documents[index].data['uidCurr'] : snapshot.data.documents[index].data['uidOther']),
                    builder: (context, ss) {
                      User user = Provider.of<User>(context);
                      return ChatRoomsTile(snapshot.data.documents[index].data['chatroomID']
                            .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                            snapshot.data.documents[index].data['chatroomID'], user, this.user);
                    },
                  ),
//                  Divider(
//                    color: Colors.grey[600],
//                    height: 0,
//                    thickness: 1,
//                  )
                ],
              );
            }) : Container();
      },
    );
  }

//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//  Future initialize() async {
//    final NotificationService notificationService = new NotificationService();
//    return await notificationService.initialise();
//  }
//  void configLocalNotification() {
//    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
//    var initializationSettingsIOS = new IOSInitializationSettings();
//    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
//    flutterLocalNotificationsPlugin.initialize(initializationSettings);
//  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUsernameSharedPreferences();
    Constants.myHandle = await HelperFunctions.getUserHandleSharedPreferences();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
    setState(() {
    });
    print("${Constants.myName}" + " is my name");
    print("${Constants.myHandle}");
  }


  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    user = Provider.of<User>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home : Scaffold(
        backgroundColor: Colors.orange[500],
        //backgroundColor: Colors.orange[300],
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            begin: Alignment.topLeft,
//            end: new Alignment(-1, -1),
//            colors: [Colors.deepPurple[800], Colors.purpleAccent[700], Colors.deepPurple[300]],
//          ),
//        ),
        body: Center(
          child: Column(
            children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),//const EdgeInsets.all(15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
              chatRoomList()
          ],
        )
      ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.deepPurpleAccent,
            elevation: 4,
            hoverColor: Colors.green,
            splashColor: Colors.green,
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                    Chats(),
                )
              );
//              QuerySnapshot _querySnapshot = Provider.of<QuerySnapshot>(context, listen: false);
//              if (_querySnapshot != null) {
//                showSearch(
//                    context: context,
//                    delegate: UserSearch(_querySnapshot, user)
//                );
//              } else {
//                await Future.delayed(Duration(seconds: 1))
//                    .whenComplete(() => _querySnapshot = Provider.of<QuerySnapshot>(context, listen: false));
//                showSearch(
//                    context: context,
//                    delegate: UserSearch(_querySnapshot, user)
//                );
//              }
            },
            label: new Icon(Icons.message, color: Colors.white)),
      ),
    );
  }
}
class ChatRoomsTile extends StatefulWidget {
  final String name;
  final String chatRoomID;
  final User user;
  final User currUser;
  ChatRoomsTile(this.name, this.chatRoomID, this.user, this.currUser);

  @override
  _ChatRoomsTileState createState() => _ChatRoomsTileState();
}

class _ChatRoomsTileState extends State<ChatRoomsTile> {
  List<User> toChecks = new List<User>();
  setProfileDialog(BuildContext context) {
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (context) {
      return AlertDialog(
        title: Text(
          "Available timings",
        ),
        content: Container(
          child: Row(
            children: <Widget>[
              Text(
                Constants.myName == null || Constants.myName.isEmpty
                    ? 'Please update your name at Profile.'
                    : 'Please update your handle at Profile.',
                style: GoogleFonts.biryani(
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            //color: Colors.deepPurple,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
                'Done'
            ),
          )
        ],
      );
    });
  }

//  showContactTimetable(User user) {
//    return MaterialApp(
//      home: Scaffold(),
//    );
//  }

  blockContact(){
    return MaterialApp(
      home: Scaffold(),
    );
  }

  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    User currUser = Provider.of<User>(context);
    return Container(
      height: 80,
      width: 500,
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(width: 5),
            Container(
              //padding: EdgeInsets.only(left: 5),
//              margin: EdgeInsets.only(left: 1),
              height: 54, width: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(54),
              ),
              child: Text("${widget.name.isNotEmpty ? widget.name.substring(0,1).toUpperCase() : "-"}",
              style: TextStyle(fontSize: 18,color: Colors.white),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
              child: Container(width: 100,
                  child: Text(widget.name,
                    style: GoogleFonts.actor(fontSize: 16, fontWeight: FontWeight.w400),
                  )
              ),
            ),
            Spacer(),
            IconButton(
              color: Colors.lightBlueAccent,
              icon: Icon(
                Icons.send
              ),
              onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatscreenRedirect(widget.chatRoomID),
                      )
                  );
              },
              iconSize: 20,
            ),
            SizedBox(width: 1,),
            PopupMenuButton<String>(
              color: Colors.white54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22.5),
              ),
              elevation: 4,
              onSelected: (String choice) async => {
                if (choice == 'Meet') {
                  //setProfileDialog(context),
                  toChecks.add(widget.user),
//                  print(widget.user.name),
//                  print(currUser.name),
////                  MeetingHandler handler = ,
//                  MeetingRequestPage(new MeetingHandler(currUser, toChecks))
                      showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext cont) {
                        return Dialog(
                            child: Provider<User>.value(
                                value: Provider.of<User>(context) ?? widget.currUser,
                                child: Stack(
                                    children: [
                                      MeetingRequestPage(
                                          new MeetingHandler(widget.currUser, toChecks), true
                                      ),
                                      BackButton(
                                        onPressed: () async {
                                          Navigator.pop(cont);
                                        },
                                      )
                                    ]
                                )
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            )
                        );
                      }
                  )
                } else if (choice == Choices.timetable) {
//              Navigator.of(context).push(
//              MaterialPageRoute(
//                builder: (context) =>
//                    Chats(),
//              )
//          );
                Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                  Provider<User>.value(value: widget.user,
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: Scaffold(
//                        appBar: AppBar(
//                          elevation: 0,
//                          backgroundColor: Colors.transparent,
//                          leading: IconButton(
//                            icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
//                            onPressed: () {
//                              Navigator.pop(context);
//                            },
//                          ),
//                        ),
                          backgroundColor: Colors.white,
                          body: TimeTableWidget(),
                        floatingActionButton: FloatingActionButton.extended(
                            backgroundColor: Colors.transparent,
                            elevation: 5,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            label: new Icon(Icons.arrow_back, color: Colors.white, size: 24,)
                      )
                      ),
                    )
                  )
                  )
                )
                } else if (choice == 'Block'){
                  blockContact()
                } else if (choice == 'Delete') {
                  await databaseMethods.deleteChatroom(widget.chatRoomID)
                }
              },
              itemBuilder: (BuildContext context)  {
                return <PopupMenuEntry<String>>[
                   PopupMenuItem<String>(
                    value: Choices.meet,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.people, color: Colors.lightBlueAccent,),
                          SizedBox(width: 15,),
                          Text(Choices.meet, style: GoogleFonts.actor(color: Colors.black),)
                        ],
                      )
                  ),
                  PopupMenuItem<String>(
                      value: Choices.timetable,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.calendar_today,color: Colors.deepPurple,),
                          SizedBox(width: 15,),
                          Text(Choices.timetable, style: GoogleFonts.actor(color: Colors.black),)
                        ],
                      )
                  ),
                  PopupMenuItem<String>(
                      value: Choices.block,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.block, color: Colors.red,),
                          SizedBox(width: 15,),
                          Text(Choices.block, style: GoogleFonts.actor(color: Colors.black),)
                        ],
                      )
                  ),
                  PopupMenuItem<String>(
                      value: Choices.delete,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.delete, color: Colors.grey,),
                          SizedBox(width: 15,),
                          Text(Choices.delete, style: GoogleFonts.actor(color: Colors.black),)
                        ],
                      )
                  ),
                ];
                /*return Choices.choices.map((String choice){
                  return PopupMenuItem<String> (
                    value: choice,
                    child: Text(choice, style: GoogleFonts.actor(color: Colors.white),),
                  );
                }).toList();*/
              },
            )
          ],
        ),
      ),
    );
  }
}
class Choices {
  static const String meet = 'Meet';
  static const String timetable = 'View';
  static const String block = 'Block';
  static const String delete = 'Delete';
  static const List<String> choices = <String>[meet, timetable, block, delete];
}
class Pair {
  String timings;
  bool isFinished;
  Pair(String timings, bool isFinished) {
    this.timings = timings;
    this.isFinished = isFinished;
  }
}