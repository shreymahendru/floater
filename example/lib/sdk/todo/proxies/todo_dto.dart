import 'package:example/sdk/todo/model/priority.dart';

class TodoDto {
  final String id;
  final String title;
  final String description;
  final Priority priority;
  final bool isComplete;

  TodoDto(
      this.id, this.title, this.description, this.priority, this.isComplete);
}
