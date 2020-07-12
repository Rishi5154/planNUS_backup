import 'package:plannusandroidversion/models/timetable/timetable_event.dart';

class Rateable {
  final String id;
  final TimeTableEvent event;
  double rating;
  int votes;
  Rateable(this.id, this.event) {
    this.rating = 0;
    this.votes = 0;
  }

  set rate(int rating) {
    this.votes++;
    this.rating = (this.rating + rating) / votes;
  }
}