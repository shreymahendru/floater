import 'package:example/sdk/todo/proxies/todo.dart';

class TodoUpdatedEvent {
  final Todo todo;
  TodoUpdatedEvent(this.todo);
}
