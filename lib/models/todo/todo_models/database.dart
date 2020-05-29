import 'package:flutter/foundation.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo.dart';

part 'database.g.dart';

@UseMoor(tables: [
  Todo
], queries: {
  '_getByType':
  'SELECT * FROM todo WHERE todo_type = ? order by is_finish, date, time',
  '_completeTask': 'UPDATE todo SET is_finish = 1 WHERE id = ?',
  '_deleteTask': 'DELETE FROM todo WHERE id = ?'
})
class TodoDatabase extends _$TodoDatabase with ChangeNotifier {
  // we tell the database where to store the data with this constructor
  TodoDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'todos_file.sqlite'));

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  Stream<List<TodoData>> getTodoByType(int type) => watchGetByType(type);

  Future insertTodoEntries(TodoData entry) async {
    return transaction((tx) async {
      await tx.into(todo).insert(entry);
    });
  }

  Future completeTodoEntries(int id) {
    return transaction((tx) async {
      await _completeTask(id);
    });
  }

  Future deleteTodoEntries(int id) {
    return transaction((tx) async {
      await _deleteTask(id);
    });
  }
}