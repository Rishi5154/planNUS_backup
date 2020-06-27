import 'package:plannusandroidversion/models/timetable/activity.dart';

class Rateable {
  final Activity activity;
  int rating;

  Rateable(this.activity);

  set rate(int rating) {
    this.rating = rating;
  }
}