import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chatscreen.dart';
import 'constants.dart';
import '../services/database.dart';
import 'helperfunctions.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

String _myName;
String _myHandle;

class _ChatsState extends State<Chats> {
  TextEditingController searchTextEditingController =
      new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    //getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUsernameSharedPreferences();
    _myHandle = await HelperFunctions.getUserHandleSharedPreferences();

    setState(() {
    });
    print("$_myName");
    print("$_myHandle");
  }

  initiateSearch() {
    databaseMethods
        .getUserByHandle(searchTextEditingController.text)
        .then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  getChatRoomId(String a, String b) {
    print(b.substring(0, 1));
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  createChatRoomToStartConversation({String name}) {
    print(Constants.myName + " is now");
    print(name + " is here");
    print(Constants.myName /*+ " is here"*/);
    if (name != Constants.myName) {
      List<String> users = [name, Constants.myName];
      String chatRoomID = getChatRoomId(name, Constants.myName);
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomID": chatRoomID
      };
      DatabaseMethods().createChatRoom(chatRoomID, chatRoomMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Chatscreen(chatRoomID)));
    } else {
      print("you can't send a msg to yourself!");
    }
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.documents.length,
            itemBuilder: (context, index) {
              return searchTile(
                  name: searchSnapshot.documents[index].data['name'],
                  handle: searchSnapshot.documents[index].data['handle']);
            })
        : Container();
  }

  Widget searchTile({String name, String handle}) {
    print(name);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                Text(handle,
                    style: TextStyle(fontSize: 14, color: Colors.white))
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                print(name);
                createChatRoomToStartConversation(name: name);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text("Message"),
              ),
            )
          ],
        ));
  }

  final formKey = GlobalKey<FormState>(); // 'id' of form
  String error = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                      icon: new Icon(Icons.search, color: Colors.blue),
                      onPressed: () {
                        if (Constants.myName == null || Constants.myName.isEmpty) {
                          setState(() {
                            error = 'Please update your name at Profile!';
                          });
                        } else if (Constants.myHandle == null || Constants.myHandle.isEmpty) {
                          setState(() {
                            error = 'Please update your handle at Profile!';
                          });
                        } else if (searchTextEditingController.text == Constants.myHandle) {
                          setState(() {
                            error = "You can't search for yourself! ";
                          });
                        } else {
                          initiateSearch();
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
      ),
    );
  }
}
