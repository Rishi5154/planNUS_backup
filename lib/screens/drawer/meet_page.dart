import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:provider/provider.dart';
import 'package:plannusandroidversion/models/meeting/meeting_handler.dart';

class MeetPage extends StatefulWidget {
  @override
  _MeetPageState createState() => _MeetPageState();
}

class _MeetPageState extends State<MeetPage> {
  final TextEditingController _textEditingController = new TextEditingController();
  List<User> toChecks = new List<User>();
  String _errorCode = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textEditingController,
                  onSubmitted: (handle) async {
                    User toAdd;
                    try {
                      toAdd = await DatabaseMethods(uid: Provider.of<User>(context, listen: false).uid)
                          .getUserByHandle(handle)
                          .then((val) => User.fromJson(val.documents[0].data['user']));
                      setState(() {
                        toChecks.add(toAdd);
                        _textEditingController.clear();
                      });
                    } catch (e) {
                      setState(() {
                        _errorCode = "User not found";
                        _textEditingController.clear();
                      });
                    }
                  },
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: toChecks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.lightGreenAccent,
                        child: ListTile(
                          title: Text(toChecks[index].name),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.0, child: Text(_errorCode, style: TextStyle(fontSize: 10.0, color: Colors.red),)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                        color: Colors.grey[300],
                        onPressed: () {
                          MeetingHandler meeting = new MeetingHandler(Provider.of<User>(context, listen: false), toChecks);
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext cont) {
                                return Dialog(
                                    child: Provider<User>.value(
                                        value: Provider.of<User>(context),
                                        child: Stack(
                                            children: [
                                              meeting.showCommonFreeTiming(cont),
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
                          );
                        },
                        child: Text('Meet')
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                        color: Colors.grey[300],
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')
                    ),
                  ),
                ],
              )
            ]
        )
    );
  }
}
