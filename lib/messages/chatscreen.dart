import 'package:flutter/material.dart';
import 'package:plannusandroidversion/shared/loading.dart';

import 'constants.dart';
import '../services/database.dart';

class Chatscreen extends StatefulWidget {
  final String chatRoomID;
  Chatscreen(this.chatRoomID);
  @override
  _ChatscreenState createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessagesStream;
  ScrollController _scrollController = new ScrollController();

  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          MessageTile(snapshot.data.documents[index]
                              .data["message"],
                              snapshot.data.documents[index].data["sendBy"] ==
                                  Constants.myName),
                        ],
                      );
                    }
                ),
              ),
            ),
            SizedBox(height: 60),
          ],
        ) : Loading();
      }
    );
  }

  sendMessage(){
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomID, messageMap);
      messageController.text = '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseMethods.getConversationMessages(widget.chatRoomID).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Stack(
            children: [
              chatMessageList(),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.deepPurpleAccent[400],
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                              enabledBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25),
                                borderSide: new BorderSide(
                                  color: Colors.white,
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25),
                                borderSide: new BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50, width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.amberAccent[700],
                          ),
                          //padding: EdgeInsets.all(12),
                          margin: EdgeInsets.only(left: 15),
                          child: IconButton(
                            icon: Icon(Icons.send),
                            iconSize: 35,
                            onPressed: () async {
                              sendMessage();
                              await _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
                            },
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  )
              )
            ],
          )
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  MessageTile(this.message, this.isSentByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSentByMe ? 0 : 24, right: isSentByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical:16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSentByMe ? [const Color(0xFFFFCA28), const Color(0xFFFFB300)]
                  : [const Color(0xFFB388FF),const Color(0xFF7C4DFF)],
            ),
            borderRadius: isSentByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)
            )
        ),
        child: Text(message,
            style: TextStyle(
                color: Colors.black,
                fontSize: 17
            )),
      ),
    );
  }
}
