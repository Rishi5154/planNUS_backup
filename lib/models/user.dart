import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/meeting/custom_notification.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'timetable.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String uid;
  String name;
  TimeTable timetable;
//  int phoneNumber;
//  bool schedule = false;
  List<CustomNotification> unread;


  User({this.uid, this.name}) {
    timetable = TimeTable.emptyTimeTable();
    unread = new List<CustomNotification>();
  }

  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Future<void> changeName(String name) {
    this.name = name;
    return update();
  }
//
//  Future addPhoneNumber(int number) {
//    this.phoneNumber = number;
//    return update();
//  }

  Future<void> addUnread(CustomNotification unreadNotification) {
    try {
      this.unread.add(unreadNotification);
      print('added unread notification');
      return DatabaseMethods(uid: this.uid).updateUserData2(this);
    } catch (e) {
      print('not added');
      return this.update();
    }
  }

  Future<void> removeNotification(CustomNotification notification) {
    int hash = notification.hashCode;
    unread.removeWhere((x) => x.hashCode == hash);
    return update();
  }

  Future<void> update() async {
    return DatabaseMethods(uid: this.uid).updateUserData2(this);
  }
}