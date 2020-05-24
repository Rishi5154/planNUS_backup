import 'package:flutter/material.dart';
import 'package:plannusandroidversion/messages/chats.dart';
import 'package:plannusandroidversion/messages/chatscreen.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/messages/database.dart';
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

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return ChatRoomsTile(snapshot.data.documents[index].data['chatroomID']
                  .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                  snapshot.data.documents[index].data['chatroomID']);
            }) : Container();
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home : Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30),
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Chatscreen(chatRoomID)
        ));
//        Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (context) =>
//                  Chatscreen(chatRoomID),
//            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            Container(
              height: 40, width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text("${name.isNotEmpty ? name.substring(0,1).toUpperCase() : "-"}"),
            ),
            SizedBox(width: 8),
            Text(name)
          ],
        ),
      ),
    );
  }
}
