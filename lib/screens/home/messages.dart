import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plannusandroidversion/messages/chats.dart';
import 'package:plannusandroidversion/messages/chatscreenredirect.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/models/timetable.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/messages/helperfunctions.dart';
import 'package:plannusandroidversion/services/auth.dart';

class Messages extends StatefulWidget {

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  AuthService auth = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;
  Stream usersStream;

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
                  ChatRoomsTile(snapshot.data.documents[index].data['chatroomID']
                      .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                      snapshot.data.documents[index].data['chatroomID']),
                  Divider(
                    color: Colors.grey[600],
                    height: 0,
                    thickness: 1,
                  )
                ],
              );
            }) : Container();
      },
    );
  }
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

  queryTimings() async {
    TimeTable currUserTimetable = await databaseMethods.getUserTimetable(AuthService.currentUser.uid);
    List<List<Pair>> list = new List<List<Pair>>(7);
    currUserTimetable.timetable.forEach((key, value) {
      int k = key as int;
      List<Pair> curr = list.removeAt(k);
      curr.add(new Pair('0800-0900', value['0800-0900']['isFinish']));
      curr.add(new Pair('0900-1000', value['0900-1000']['isFinish']));
      curr.add(new Pair('1000-1100', value['1000-1100']['isFinish']));
      curr.add(new Pair('1100-1200', value['1100-1200']['isFinish']));
      curr.add(new Pair('1200-1300', value['1200-1300']['isFinish']));
      curr.add(new Pair('1300-1400', value['1300-1400']['isFinish']));
      curr.add(new Pair('1400-1500', value['1400-1500']['isFinish']));
      curr.add(new Pair('1500-1600', value['1500-1600']['isFinish']));
      curr.add(new Pair('1600-1700', value['1600-1700']['isFinish']));
      curr.add(new Pair('1700-1800', value['1700-1800']['isFinish']));
      curr.add(new Pair('1800-1900', value['1800-1900']['isFinish']));
      curr.add(new Pair('1900-2000', value['1900-2000']['isFinish']));
      list.insert(k - 1, curr);
    });
    //print(list.)
  }

//  syncTimetable(String handle) async {
//    User user = await databaseMethods.getOtherUserViaHandle(handle);
//    return Provider<User>.value(value: user,
//        child: MaterialApp(
//          home: Scaffold(
//              backgroundColor: Colors.yellow, body: TimeTableWidget()),
//        ));
//  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home : Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 0),//const EdgeInsets.all(15),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                    Chats(),
                )
              );
            },
            label: new Icon(Icons.message, color: Colors.white)),
      ),
    );
  }
}
class ChatRoomsTile extends StatelessWidget {
  final String name;
  final String chatRoomID;
  ChatRoomsTile(this.name, this.chatRoomID);

  // query timings
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
                Constants.myName == null || Constants.myName.isEmpty ? 'Please update your name at Profile.'
                    :  'Please update your handle at Profile.',
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

  // timetable display of contacts
  showContactTimetable() {
    return MaterialApp(
      home: Scaffold(),
    );
  }

  // block contact

  blockContact(){
    return MaterialApp(
      home: Scaffold(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: <Widget>[
          Container(
            height: 50, width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text("${name.isNotEmpty ? name.substring(0,1).toUpperCase() : "-"}",
            style: TextStyle(fontSize: 18),),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
            child: Container(width: 100, child: Text(name, style: GoogleFonts.biryani(fontSize: 16),)),
          ),
          SizedBox(width: 100),
          IconButton(
            icon: Icon(
              Icons.send
            ),
            onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatscreenRedirect(chatRoomID),
                    )
                );
            },
            iconSize: 20,
          ),
          SizedBox(width: 1,),
          PopupMenuButton<String>(
            onSelected: (String choice) => {
              if (choice == 'Meet') {
                setProfileDialog(context)
              } else if (choice == 'Timetable display') {
                showContactTimetable()
              } else {
                blockContact()
              }
            },
            itemBuilder: (BuildContext context)  {
              return Choices.choices.map((String choice){
                return PopupMenuItem<String> (
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
    );
  }
}
class Choices {
  static const String meet = 'Meet';
  static const String timetable = 'Timetable display';
  static const String block = 'Block';
  static const List<String> choices = <String>[ meet, timetable, block ];
}
class Pair {
  String timings;
  bool isFinished;
  Pair(String timings, bool isFinished) {
    this.timings = timings;
    this.isFinished = isFinished;
  }
}