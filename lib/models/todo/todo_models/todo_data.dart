import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/services/database.dart';
import 'package:provider/provider.dart';

part 'todo_data.g.dart';

@JsonSerializable(explicitToJson: true)
class TodoData {
  Map<int, Todo> tasks;
  List counter = [0];

  TodoData() {
    this.tasks = new Map<int, Todo>();
  }

  int get count {
    int result = counter[0];
    counter[0]++;
    return result;
  }

  Stream<List<Todo>> getTodoByType(int type) {
    if (tasks == null) {
      return Stream.value(new List<Todo>());
    } else {
      return Stream.value(tasks.values.toList());
    }
  }

  void insertTodoEntries(DateTime date, DateTime time, String task, String description, int todoType) {
    Todo entry = new Todo(date: date, time: time, isFinish: false, task: task, description: description, todoType: todoType, id: this.count);
    tasks[entry.id] = entry;
  }

  void completeTodoEntries(int id) {
    print(id);
    try {
      Todo task = tasks[id];
      task.toggleComplete();
      tasks[id] = task;
    } catch (e) {
    }
  }

  void deleteTodoEntries(int idToDelete) {
    tasks.removeWhere((id, value) => id == idToDelete);
  }

  factory TodoData.fromJson(Map<String, dynamic> data) => _$TodoDataFromJson(data);

  Map<String, dynamic> toJson() => _$TodoDataToJson(this);

  Future<void> update(BuildContext context) async {
    String uid = Provider.of<User>(context, listen: false).uid;
    return await DatabaseMethods(uid: uid).updateUserTodoData(this);
  }

  Future<void> updateAdds(BuildContext context, Todo entry) async {
    String uid = Provider.of<User>(context, listen: false).uid;
    TodoData data = await DatabaseMethods(uid: uid).users.document(uid).get().then((val) => TodoData.fromJson(val['tasks']));
    data.insertTodoEntries(entry.date, entry.time, entry.task, entry.description, entry.todoType);
    return await DatabaseMethods(uid: uid).updateUserTodoData(data);
  }
}