import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plannusandroidversion/models/timetable/timetable_widget.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:plannusandroidversion/shared/helperwidgets.dart';
import 'package:provider/provider.dart';
import 'chatscreen.dart';
import 'constants.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'helperfunctions.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}


class _ChatsState extends State<Chats> {
  TextEditingController searchTextEditingController =
      new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  QuerySnapshot timetableSnapshot;
  Stream usersStream;
  String otherUid;
  User user;

  @override
  void initState() {
    super.initState();
  }

  getUserInfo() async {
    String myName = await HelperFunctions.getUsernameSharedPreferences();
    String myHandle = await HelperFunctions.getUserHandleSharedPreferences();
    print("$myName");
    print("$myHandle");
  }

   initiateSearch() async {
    try {
      await databaseMethods
          .getUserByHandle(searchTextEditingController.text)
          .then((value) {
        setState(() {
          searchSnapshot = value;
          otherUid = value.documents[0].documentID;
        });
      });
      await databaseMethods.userTimetables
          .document(otherUid)
          .get()
          .then((value) {
        setState(() {
          user = User.fromJson(value.data['user']);
        });
      });
    } catch (e) {
      print("User not found!");
      HelperWidgets.flushbar("User not found!", Icons.warning)..show(context);
    }
  }

  getChatRoomId(String a, String b) {
    print(b.substring(0, 1));
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  createChatRoomToStartConversation({String name,/*String otherUid,*/ User user}) {
    print(Constants.myName + " is now");
    print(name + " is here");
    print(Constants.myName /*+ " is here"*/);
    if (name != Constants.myName) {
      List<String> users = [name, Constants.myName];
      String chatRoomID = getChatRoomId(name, Constants.myName);
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomID": chatRoomID,
        "otheruser" : user.toJson(),
        "uidCurr" : AuthService.currentUser.uid,
        "uidOther" : user.uid
      };
      DatabaseMethods().createChatRoom(chatRoomID, chatRoomMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Chatscreen(chatRoomID)));
    } else {
      print("you can't send a msg to yourself!");
    }
  }


  Widget searchList() {
    return searchSnapshot != null && user != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.documents.length,
            itemBuilder: (context, index) {
              return searchTile(
                  name: searchSnapshot.documents[index].data['name'],
                  handle: searchSnapshot.documents[index].data['handle'],
                  user: user);
            })
        : Container();
  }

  Widget searchTile({String name, String handle,/*String otherUid,*/ User user}) {
    print(name);
    return Container(
        height: 90,
        width: 500,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Card(
          color: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 17.5, 0, 0),
                child: Container(
                  width: 100,
                  child: Column(
                    children: <Widget>[
                      Text(
                        name,
                        style: GoogleFonts.actor(fontSize: 16, color: Colors.black),
//                        textAlign: TextAlign.right,
                      ),
                      Text(handle,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(fontSize: 18, color: Colors.blueAccent,letterSpacing: 0))
                    ],
                  ),
                ),
              ),
//            Spacer(),
//            GestureDetector(
//                  onTap: () {
//                    print(name);
//                    Navigator.push(context,
//                        MaterialPageRoute(builder: (context) => Provider<User>.value(value: user,
//                            child: MaterialApp(
//                              home: Scaffold(
//                                  appBar: AppBar(
//                                    elevation: 0,
//                                    backgroundColor: Colors.transparent,
//                                    leading: IconButton(
//                                      icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
//                                      onPressed: () {
//                                        Navigator.pop(context);
//                                      },
//                                    ),
//                                  ),
//                                  backgroundColor: Colors.deepPurple,
//                                  body: TimeTableWidget()),
//                            )
//                        )
//                        )
//                    );
//                  },
//                  child: Container(
//                    decoration: BoxDecoration(
//                      color: Colors.blue,
//                      borderRadius: BorderRadius.circular(30),
//                    ),
//                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                    child: Text("Timetable"),
//                  ),
//            ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  print(name);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Provider<User>.value(value: user,
                          child: Scaffold(
                                appBar: AppBar(
                                  elevation: 0,
                                  backgroundColor: Colors.deepPurple,
                                  leading: IconButton(
                                    icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                backgroundColor: Colors.deepPurple,
                                body: TimeTableWidget(private: true,)),
                          )
                      )
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Icon(Icons.calendar_today,size: 20,),
                ),
              ),
              SizedBox(width: 15,),
              GestureDetector(
                onTap: () {
                  print(name);
                  createChatRoomToStartConversation(name: name, user: user);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Icon(Icons.message,size: 22,)/*Text("Message")*/,
                ),
              )
            ],
          ),
        ));
  }

  final formKey = GlobalKey<FormState>(); // 'id' of form
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextFormField(
                      controller: searchTextEditingController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        fillColor: Colors.grey[400],
                        filled: true,
                        hintText: 'Search user',
                        hintStyle: TextStyle(color: Colors.black),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25),
                          borderSide: new BorderSide(
                            color: Colors.white,
                            width: 2.5,
                          ),
                        ),
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                    )),
                    IconButton(
                      padding: EdgeInsets.fromLTRB(20, 2, 2, 2),
                      icon: new Icon(Icons.search, color: Colors.cyanAccent, size: 30,),
                      onPressed: () async {
                        if (Constants.myName == null || Constants.myName.isEmpty) {
                          HelperWidgets.topFlushbar('Please update your name at Profile!'
                              , Icons.perm_identity)..show(context);
                        } else if (Constants.myHandle == null || Constants.myHandle.isEmpty) {
                          HelperWidgets.topFlushbar('Please update your handle at Profile!'
                              , Icons.perm_identity)..show(context);
                        } else if (searchTextEditingController.text == Constants.myHandle) {
                          HelperWidgets.topFlushbar("You can't search for yourself!"
                              , Icons.info_outline)..show(context);
                        } else {
                          initiateSearch();
                          print('${otherUid ?? 'null detected'}' + " here again!!!");
                        }
                      },
                    )
                  ],
                ),
              ),
              Container(height: 20,
                  width: 300,
                  child: Center(
                    child: Text(error,
                      style: GoogleFonts.lato(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  )
              ),
              searchList()
            ],
          ),
        ),
    );
  }
}
