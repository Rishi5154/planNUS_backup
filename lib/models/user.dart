import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo_data.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'timetable.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String uid;
  TimeTable timetable = TimeTable.emptyTimeTable();
  TodoData toDoDatabase = TodoData();
  int phoneNumber;
  bool schedule = false;
  bool initial = true;

  User({this.uid});

  void init() {
    if (initial) {
      timetable = TimeTable.emptyTimeTable();
      initial = false;
    }
  }

  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Future<void> update() async {
    return DatabaseMethods(uid: this.uid).updateUserData2(this);
  }
}