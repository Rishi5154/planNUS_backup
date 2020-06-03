import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';
@JsonSerializable(explicitToJson: true)
class Todo {
  int id;
  String task;
  DateTime date;
  DateTime time;
  bool isFinish;
  int todoType;
  String description;

  Todo({this.date, this.time, this.isFinish, this.task, this.description, this.todoType, this.id});

  factory Todo.fromJson(Map<String, dynamic> data) => _$TodoFromJson(data);

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  void toggleComplete() {
    isFinish = true;
  }
}

enum TodoType { TYPE_TASK, TYPE_EVENT }
