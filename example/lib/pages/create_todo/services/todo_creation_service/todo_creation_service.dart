import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:example/sdk/todo/services/todos_service/todos_service.dart';
import 'package:floater/floater.dart';

class TodoCreationService {
  final _todosService = ServiceLocator.instance.resolve<TodosService>();

  Todo _todo;

  bool get isNewTodo => this._todo == null;

  String _title;
  String get title => this._title;

  String _description;
  String get description => this._description;

  void init(Todo todo) {
    this._todo = todo;
    this._title = todo?.title;
    this._description = todo?.description;
  }

  void setTitle(String title) {
    given(title, "title").ensureHasValue().ensure((t) => t.trim().isNotEmpty && t.length < 50);

    this._title = title;
  }

  void setDescription(String description) {
    given(description, "description").ensure((t) => t.trim().isNotEmpty && t.length < 500);

    this._description = description;
  }

  Future<void> complete() async {
    given(this, "this").ensure((t) => t._title != null);

    if (this.isNewTodo) {
      await this._todosService.createTodo(this._title, this._description);
      return;
    }

    await this._todo.update(this._title, this._description);
  }
}
