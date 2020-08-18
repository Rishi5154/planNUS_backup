import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plannusandroidversion/models/rating/rateable.dart';
import 'package:plannusandroidversion/models/timetable/timetable_event.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/screens/drawer/detailedevent.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:plannusandroidversion/services/locationservice.dart';

class EventSearch extends SearchDelegate<String> {

  User currUser;
  QuerySnapshot ss;
  List<String> added = [];
  List<String> events = []; // to build suggestions
  List<Rateable> event = new List<Rateable>();

  EventSearch(this.ss, this.currUser) {
    try {
      for (var doc in ss.documents) {
        final ref = doc.data;
        print(ref['eventTitle']);
        Rateable _rateable = Rateable.fromJson(ref['rating']);
        events.add(_rateable.event.name);
      }
    } catch (e) {
      print(e);
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
    final _events = events;
    final suggestionList = query.isEmpty
        ? [] : _events.where((str) => str.toLowerCase().startsWith(query.toLowerCase())).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
          onTap: () async {
            final String selectedEvent = suggestionList[index];
            added.add(selectedEvent);
            events.removeWhere((event) => event.toLowerCase() == selectedEvent.toLowerCase());
            Rateable toAdd = await DatabaseMethods().getEventByTitle(selectedEvent);
            event.add(toAdd);
            query = '';
            print(toAdd.event.name);
            TimeTableEvent eve = toAdd.event;
            try {
              print("getting position " + eve.location);
//              Position place = await Geolocator().placemarkFromAddress(
//                  eve.location)
//                  .then((value) => value.first.position);
              Position place = await LocationService.getCoordinatesFromLocation(eve.location);
              return Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      DetailedEvent(eve.name, toAdd, place.longitude, place.latitude),
                  )
              );
            } catch (e) {
              print(e.toString());
              //HelperWidgets.flushbar("Event location unavailable!", Icons.place)..show(context);
              events.add(toAdd.event.name);
              return Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                    DetailedEvent(eve.name, toAdd, null, null),
                  )
              );
            }
            //showResults(context);
          },
          leading: Icon(Icons.event_note, color: Colors.black,),
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