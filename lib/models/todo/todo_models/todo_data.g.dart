// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoData _$TodoDataFromJson(Map<String, dynamic> json) {
  return TodoData()
    ..tasks = (json['tasks'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k),
          e == null ? null : Todo.fromJson(e as Map<String, dynamic>)),
    );
}

Map<String, dynamic> _$TodoDataToJson(TodoData instance) => <String, dynamic>{
      'tasks':
          instance.tasks?.map((k, e) => MapEntry(k.toString(), e?.toJson())),
    };
