import 'package:example/pages/routes.dart';
import 'package:example/pages/todos/todos_page.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:example/sdk/todo/services/todos_service/todos_service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class TodosPageState extends WidgetStateBase<TodosPage> {
  final _navigator = NavigationService.instance.retrieveNavigator("/");
  final _todosService =
      ServiceLocator.instance.resolve<TodosService>(); // getting the todoService installed

  List<Todo> _todos;
  List<Todo> get todos => this._todos ?? [];

  TodosPageState() : super() {
    this.onInitState(() {
      this._loadTodos();
    });
  }

  Future<void> onTodoPressed(Todo todo) async {
    given(todo, "todo").ensureHasValue();
  }

  Future<void> onEditTodoPressed(Todo todo) async {
    given(todo, "todo").ensureHasValue();
    this._navigator.pushNamed(
      NavigationService.instance.generateRoute(Routes.createTodo),
      arguments: {
        "todo": todo,
      },
    );
  }

  void onAddTodoPressed() {
    this._navigator.pushNamed(
      NavigationService.instance.generateRoute(Routes.createTodo),
      arguments: {
        "todo": null,
      },
    );
  }

  Future<void> _loadTodos() async {
    this.showLoading();
    try {
      this._todos = await this._todosService.getAllTodos();
    } catch (e) {
      debugPrint(e);
      return;
    } finally {
      this.hideLoading();
    }
  }
}
