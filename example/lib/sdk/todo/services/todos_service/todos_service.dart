import 'package:example/sdk/todo/model/priority.dart';
import 'package:example/sdk/todo/proxies/todo.dart';

abstract class TodosService {
  Future<void> createTodo(String title, String description, Priority priority);
  Future<List<Todo>> getAllTodos();
  Future<Todo> getTodo(String id);
  Future<void> removeTodo(Todo todo);
}
