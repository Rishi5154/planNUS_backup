import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/meeting/meeting_handler.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/screens/drawer/meeting_request_page.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:provider/provider.dart';

class UserSearch extends SearchDelegate<String> {

  User requester;
  QuerySnapshot _querySnapshot;
  List<String> added = [];
  List<String> usersNames = [];
  List<String> usersHandles = [];
  List<User> toChecks = new List<User>();

  UserSearch(this._querySnapshot, this.requester) {
    try {
      for (var doc in _querySnapshot.documents) {
        final ref = doc.data;
        usersNames.add(ref['name']);
        usersHandles.add(ref['handle']);
      }
      init();
    } catch (e) {
      print(e);
    }
  }

  init() async {
    String requesterName = await DatabaseMethods().getNameByUID(requester.uid);
    String requesterHandle = await DatabaseMethods().getHandleByUID(requester.uid);
    usersNames.remove(requesterName);
    usersHandles.remove(requesterHandle);
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
    return ListView.builder(
      itemCount: added.length + 1,
      itemBuilder: (context, index) {
        if (index < added.length) {
          return Card(
            color: Colors.lightGreenAccent,
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(
                added[index],
              ),
            ),
          );
        } else {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                    child: RaisedButton(
                      child: Text('Meet'),
                      onPressed: () {
                        MeetingHandler meetingHandler = new MeetingHandler(requester, toChecks);
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext cont) {
                              return Dialog(
                                  child: Provider<User>.value(
                                      value: Provider.of<User>(context) ?? requester,
                                      child: Stack(
                                          children: [
                                            MeetingRequestPage(
                                                meetingHandler, false
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
                        );
                      },
                    )
                ),
                SizedBox(width: 30.0,),
                Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                    child: RaisedButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        close(context, null);
                      },
                    )
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? []
        : usersNames.where((name) => name.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
          onTap: () async {
            final handle = suggestionList[index];
            added.add(handle);
            usersNames.removeWhere((name) => name == handle);
            User toAdd = await DatabaseMethods().getUserByName(handle)
                .then((val) => val.documents[0].documentID)
                .then((uid) async {
              return await DatabaseMethods(uid: uid).getUserByUID(uid);});
            toChecks.add(toAdd);
            query = '';
            showResults(context);
          },
          leading: Icon(Icons.person),
          title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                        text: suggestionList[index].substring(query.length),
                        style: TextStyle(color: Colors.grey)
                    )
                  ]
              )
          )
      ),
      itemCount: suggestionList.length,
    );
  }
}

