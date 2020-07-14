import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/rating/add_ratings_page.dart';
import 'package:plannusandroidversion/models/rating/rateable.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/shared/loading.dart';
import 'package:provider/provider.dart';

class RatingPage extends StatefulWidget {

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {

  QuerySnapshot _querySnapshot;
  User user;
  List<Rateable> getRateable() {
    List<Rateable> results = new List<Rateable>();
    try {
      for (var doc in _querySnapshot.documents) {
        results.add(Rateable.fromJson(doc.data['rating']));
      }
    } catch (e) {
      print(e);
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    _querySnapshot = Provider.of<QuerySnapshot>(context, listen: true);
    user = Provider.of<User>(context);
    List<Rateable> rateable = [];
    rateable = getRateable();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ratings'),
            IconButton(
              icon: Icon(Icons.add_comment),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AddRatingsPage(user.timetable, user);
                  }
                );
              },
            )
          ]
        ),
      ),
      body: Container(
        child: rateable == null
          ? Loading()
          : ListView.builder(
          itemCount: rateable.length,
          itemBuilder: (context, index) {
            Rateable _rateable = rateable[index];
            print(_rateable.currRating);
            return ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    List<String> voters = _rateable.reviews.keys.toList();
                    return SimpleDialog(
                      title: Center(child: Text('${_rateable.event.name}\'s Reviews')),
                      children: voters.map((name) => Container(
                        padding: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text('$name:',
                                style: TextStyle(fontSize: 13, color: Colors.blue[800])
                              )
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("${_rateable.reviews[name]}",
                                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10, color: Colors.grey[700]),
                              )
                            )
                          ]
                        ),
                      )).toList()
                    );
                  }
                );
              },
              title: Text(_rateable.event.name),
              trailing: RatingBar(
                allowHalfRating: true,
                initialRating: _rateable.currRating,
                minRating: 0,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.yellowAccent[400]
                ),
                onRatingUpdate: (newRating) {},
                ignoreGestures: true,
              )
            );
          },
        ),
      ),
    );
  }
}
