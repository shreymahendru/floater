import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:floater/floater.dart';

class TodoUpdatedEvent extends Event {
  final Todo todo;
  TodoUpdatedEvent(this.todo);
}
