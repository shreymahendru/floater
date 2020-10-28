import 'package:example/sdk/todo/proxies/todo.dart';

class TodoAddedEvent {
  final Todo todo;
  TodoAddedEvent(this.todo);
}
