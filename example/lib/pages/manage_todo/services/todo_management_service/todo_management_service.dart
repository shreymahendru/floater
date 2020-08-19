import 'package:example/sdk/todo/model/priority.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:example/sdk/todo/services/todos_service/todos_service.dart';
import 'package:floater/floater.dart';

// this service is used to facilitate the flow of creation or editing of a todo
class TodoManagementService {
  final _todosService = ServiceLocator.instance.resolve<TodosService>();

  Todo _todo;

  bool get isNewTodo => this._todo == null;

  String _title;
  String get title => this._title;

  String _description;
  String get description => this._description;

  Priority _priority;
  Priority get priority => this._priority;

  void init(Todo todo) {
    this._todo = todo;
    // if a todo is passed copy the title and description or else leave it null.
    this._title = todo?.title;
    this._description = todo?.description;
    this._priority = todo?.priority;
  }

  void setTitle(String title) {
    given(title, "title")
        .ensureHasValue()
        .ensure((t) => t.trim().isNotEmpty && t.length < 50);

    this._title = title;
  }

  void setDescription(String description) {
    given(description, "description")
        .ensure((t) => t == null || (t.trim().isNotEmpty && t.length < 500));

    this._description = description;
  }

  void setPriority(Priority priority) {
    given(priority, "priority").ensureHasValue();

    this._priority = priority;
  }

  Future<void> complete() async {
    given(this, "this").ensure((t) => t._title != null);

    // if a todo was not passed that means you are creating a new one, else you are updating the todo passed.
    if (this.isNewTodo) {
      await this
          ._todosService
          .createTodo(this._title, this._description, this._priority);
      return;
    }

    await this._todo.update(this._title, this._description, this._priority);
  }

  void removeTodo() {
    this._todosService.removeTodo(_todo);
  }
}
