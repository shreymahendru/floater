import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:example/sdk/todo/services/todos_service/todos_service.dart';
import 'package:floater/floater.dart';

// this service is used to facilitate the flow of creation or editing of a todo
class TodoManagementService {
  final _todosService = ServiceLocator.instance.resolve<TodosService>();

  Todo? _todo;

  bool get isNewTodo => this._todo == null;

  String? _title;
  String? get title => this._title;

  String? _description;
  String? get description => this._description;

  Future<void> init(String? id) async {
    if (id != null) this._todo = await this._todosService.getTodo(id);
    // if a todo is passed copy the title and description or else leave it null.
    this._title = this._todo?.title;
    this._description = this._todo?.description;
  }

  void setTitle(String title) {
    given(title, "title")
        .ensure((t) => t.isNotEmptyOrWhiteSpace && t.trim().length < 50);

    this._title = title;
  }

  void setDescription(String? description) {
    given(description, "description").ensure((t) =>
        t == null || (t.isNotEmptyOrWhiteSpace && t.trim().length < 500));

    this._description = description?.trim() ?? null;
  }

  Future<void> complete() async {
    given(this, "this").ensure((t) => t._title != null);

    // if a todo was not passed that means you are creating a new one, else you are updating the todo passed.
    if (this.isNewTodo) {
      await this._todosService.createTodo(this._title!, this._description);
      return;
    }

    await this._todo!.update(this._title!, this._description);
  }
}
