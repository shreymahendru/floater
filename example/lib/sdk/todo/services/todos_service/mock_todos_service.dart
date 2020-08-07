import 'package:example/sdk/todo/proxies/mock_todo_proxy.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:example/sdk/todo/proxies/todo_dto.dart';
import 'package:example/sdk/todo/services/todos_service/todos_service.dart';
import 'package:floater/floater.dart';
import 'package:uuid/uuid.dart';

class MockTodosService implements TodosService {
  List<Todo> _allTodos = [];

  MockTodosService() {
    this._allTodos = List.generate(
        4,
        (index) => MockTodoProxy(TodoDto(
            Uuid().v1().toString(),
            "Todo number ${index + 1}",
            "This is the description for Todo number ${index + 1}",
            "Medium",
            false)));
  }

  @override
  Future<void> createTodo(
      String title, String description, String priority) async {
    given(title, "title").ensureHasValue().ensure((t) => t.trim().isNotEmpty);

    // fake network delay
    await Future.delayed(Duration(seconds: 1));

    final mockTodoDto =
        TodoDto(Uuid().v1().toString(), title, description, priority, false);

    final mockTodo = MockTodoProxy(mockTodoDto);
    this._allTodos.add(mockTodo);
  }

  @override
  Future<List<Todo>> getAllTodos() async {
    // fake network delay
    await Future.delayed(Duration(seconds: 1));

    return this._allTodos.map((e) => e).toList();
  }

  @override
  Future<Todo> getTodo(String id) async {
    given(id, "id").ensureHasValue().ensure((t) => t.trim().isNotEmpty);

    // fake network delay
    await Future.delayed(Duration(seconds: 4));

    return this._allTodos.find((e) => e.id == id);
  }

  @override
  void removeTodo(Todo todo) {
    this._allTodos.remove(todo);
  }
}
