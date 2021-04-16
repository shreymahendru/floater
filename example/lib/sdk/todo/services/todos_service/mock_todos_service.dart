import 'package:example/events/todo_added_event.dart';
import 'package:example/sdk/todo/proxies/mock_todo_proxy.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:example/sdk/todo/proxies/todo_dto.dart';
import 'package:example/sdk/todo/services/todos_service/todos_service.dart';
import 'package:floater/floater.dart';

class MockTodosService implements TodosService {
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();
  List<Todo> _allTodos = [];

  MockTodosService() {
    this._allTodos = List.generate(
        5,
        (index) => MockTodoProxy(TodoDto("tdo_${index + 1}", "Todo number ${index + 1}",
            "This is the description for Todo number ${index + 1}", false)));
  }

  @override
  Future<void> createTodo(String title, String? description) async {
    given(title, "title").ensure((t) => t.isNotEmptyOrWhiteSpace);
    given(description, "description").ensure((t) => t?.isNotEmptyOrWhiteSpace ?? true);

    if (description != null) description = description.trim();

    // fake network delay
    await Future.delayed(Duration(seconds: 1));

    final index = this._allTodos.isEmpty
        ? 1
        : this._allTodos.map((t) => int.parse(t.id.split("_")[1])).toList().orderByDesc()[0];

    final mockTodoDto = TodoDto("tdo_${index + 1}", title.trim(), description, false);

    final mockTodo = MockTodoProxy(mockTodoDto);
    this._eventAggregator.publish(TodoAddedEvent(mockTodo));
    this._allTodos.add(mockTodo);
  }

  @override
  Future<List<Todo>> getAllTodos() async {
    // fake network delay
    await Future.delayed(Duration(milliseconds: 200));
    return this._allTodos.map((e) => e).toList();
  }

  @override
  Future<Todo> getTodo(String id) async {
    given(id, "id").ensure((t) => t.isNotEmptyOrWhiteSpace);

    // fake network delay
    await Future.delayed(Duration(milliseconds: 200));

    return this._allTodos.find((e) => e.id == id)!;
  }
}
