import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/timetable/timetable_event.dart';

part 'rateable.g.dart';

@JsonSerializable(explicitToJson: true)
class Rateable {
  final TimeTableEvent event;
  double currRating;
  int votes;
  Map<String, String> reviews;

  Rateable(this.event, this.currRating, this.votes, this.reviews);

  void rate(double rating) {
    this.currRating = ((this.currRating * votes.toDouble()) + rating) / (votes + 1);
    this.votes = votes + 1;
  }

  factory Rateable.fromJson(Map<String, dynamic> data) => _$RateableFromJson(data);

  Map<String, dynamic> toJson() => _$RateableToJson(this);
}