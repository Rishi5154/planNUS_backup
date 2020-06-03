// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return Todo(
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
    isFinish: json['isFinish'] as bool,
    task: json['task'] as String,
    description: json['description'] as String,
    todoType: json['todoType'] as int,
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'task': instance.task,
      'date': instance.date?.toIso8601String(),
      'time': instance.time?.toIso8601String(),
      'isFinish': instance.isFinish,
      'todoType': instance.todoType,
      'description': instance.description,
    };
