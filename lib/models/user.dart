import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'timetable.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String uid;
  TimeTable timetable;
  int phoneNumber;
  bool schedule = false;

  User({this.uid}) {
    timetable = TimeTable.emptyTimeTable();
  }

  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Future<void> update() async {
    return DatabaseMethods(uid: this.uid).updateUserData2(this);
  }
}