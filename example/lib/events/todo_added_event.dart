import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:floater/floater.dart';

class TodoAddedEvent extends Event {
  final Todo todo;
  TodoAddedEvent(this.todo);
}
