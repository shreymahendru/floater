import 'package:example/sdk/todo/model/priority.dart';

abstract class Todo {
  String get id;
  String get title;
  String get description;
  Priority get priority;
  bool get isComplete;

  Future<void> toggleComplete();
  Future<void> update(String title, String description, Priority priority);
}
