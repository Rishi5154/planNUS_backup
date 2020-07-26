import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/services/auth.dart';
import 'package:plannusandroidversion/services/database.dart';

import 'chatscreen.dart';

class Pair{
  String name;
  String handle;
  Pair(name, handle) {
    this.name = name;
    this.handle = handle;
  }
}
class ChatSearch extends SearchDelegate<String>{

  User currUser;
  QuerySnapshot ss;
  List<String> added = [];
  Map<String, User> userMap = new Map();
  List<Pair> users = []; // to build suggestions

  getChatRoomId(String a, String b) {
    print(b.substring(0, 1));
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  ChatSearch(this.ss) {
    try {
      print("i am here!");
      for (var doc in ss.documents) {
        final ref = doc.data;
        print("i am here!");
        String name = ref['name'];
        print(ref['handle']);
        String handle = ref['handle'];
        users.add(Pair(name, handle));
      }
    } catch (e) {
      print(e);
      print("failed!");
    }
  }
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Material(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.backspace),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    createChatRoomToStartConversation({String name, User user}) {
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

    //final _users = users.toList();
    final List<Pair> usersList = query.isEmpty ? [] : users.where((handle) => handle.handle.startsWith(query)).toList();
    return ListView.builder(
        itemCount: usersList.length,
        itemBuilder: (context, index) => ListTile(
          leading:  Icon(Icons.person, color: Colors.deepPurpleAccent),
          title: RichText(
            text: TextSpan(
                text: usersList[index].handle.substring(0, query.length),
                style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                      text: usersList[index].handle.substring(query.length),
                      style: TextStyle(color: Colors.grey)
                  )
                ]
            )
          ),
          onTap: () async {
            User user = await DatabaseMethods().getUserTimetableByHandle(usersList[index].handle);
            createChatRoomToStartConversation(
                name: usersList[index].name,
                user: user
            );
          },
        )
    );
    throw UnimplementedError();
  }

}