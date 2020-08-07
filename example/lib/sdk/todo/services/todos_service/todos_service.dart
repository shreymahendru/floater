import 'package:example/sdk/todo/proxies/todo.dart';

abstract class TodosService {
  Future<void> createTodo(String title, String description, String priority);
  Future<List<Todo>> getAllTodos();
  Future<Todo> getTodo(String id);
  void removeTodo(Todo todo);
}
