import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo.dart';

part 'todo_data.g.dart';

@JsonSerializable(explicitToJson: true)
class TodoData extends ChangeNotifier {
  Map<int, Todo> tasks;
  int _counter = 0;

  TodoData() {
    this.tasks = new Map<int, Todo>();
  }

  int get count {
    return ++_counter;
  }

  Stream<List<Todo>> getTodoByType(int type) {
    if (tasks == null || tasks.isEmpty) {
      return Stream.value(new List<Todo>());
    } else {
      return Stream.value(tasks.values.toList());
    }
  }

  void insertTodoEntries(Todo entry) {
    tasks[entry.id] = entry;
    notifyListeners();
  }

  void completeTodoEntries(int id) {
    print(id);
    try {
      Todo task = tasks[id];
      task.toggleComplete();
      tasks[id] = task;
      notifyListeners();
    } catch (e) {
      print("########################## err ############# " + e.toString());
    }
  }

  void deleteTodoEntries(int id) {
    tasks.remove(tasks[id]);
    notifyListeners();
  }

  factory TodoData.fromJson(Map<String, dynamic> data) => _$TodoDataFromJson(data);

  Map<String, dynamic> toJson() => _$TodoDataToJson(this);
}