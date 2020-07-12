import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/rating/rateable.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingPage extends StatefulWidget {
  final List<Rateable> rateable;

  RatingPage(this.rateable);

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  List<Rateable> rateable;

  @override
  Widget build(BuildContext context) {
    rateable = widget.rateable;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ratings'),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ]
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: rateable.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(rateable[index].event.name),
              trailing: SmoothStarRating(

              )
            );
          },
        ),
      ),
    );
  }
}
