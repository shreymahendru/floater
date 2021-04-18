import 'package:example/events/todo_added_event.dart';
import 'package:example/pages/routes.dart';
import 'package:example/pages/todos/todos_page.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:example/sdk/todo/services/todos_service/todos_service.dart';
import 'package:example/services/bottom_nav_manager_mixin.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class TodosPageState extends WidgetStateBase<TodosPage>
    with BottomNavManagerMixin {
  // final _navigator = NavigationService.instance.retrieveNavigator("/");
  final _todosService = ServiceLocator.instance
      .resolve<TodosService>(); // getting the todoService installed
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();

  List<Todo> _todos = [];
  List<Todo> get todos => this._todos;

  bool _isTogglingTodoCompletion = false;
  bool get isTogglingTodoCompletion => this._isTogglingTodoCompletion;
  set isTogglingTodoCompletion(bool value) =>
      (this.._isTogglingTodoCompletion = value).triggerStateChange();

  TodosPageState() : super() {
    this.onInitState(() async {
      this._loadTodos();

      final persistedRoute =
          await NavigationManager.instance.retrievePersistedRoute();
      print(persistedRoute);
      if (persistedRoute != null) {
        this.currentNavigator.pushNamed(persistedRoute);
      }
    });

    this.watch<TodoAddedEvent>(
        this._eventAggregator.subscribe<TodoAddedEvent>(), (event) {
      this._todos.add(event.todo);
    });
  }

  Future<void> onTodoPressed(Todo todo) async {
    this.currentNavigator.pushNamed(
      NavigationService.instance.generateRoute(Routes.viewTodo),
      arguments: {
        "id": todo.id,
      },
    );
  }

  Future<void> onEditTodoPressed(Todo todo) async {
    this.currentNavigator.pushNamed(
      NavigationService.instance.generateRoute(Routes.manageTodo),
      arguments: {
        "id": todo.id,
      },
    );
  }

  void onAddTodoPressed() {
    this.currentNavigator.pushNamed(
      NavigationService.instance.generateRoute(Routes.manageTodo),
      arguments: {
        "id": null,
      },
    );
  }

  void toggleCompletionForTodo(Todo todo) async {
    this.isTogglingTodoCompletion = true;
    try {
      await todo.toggleComplete();
    } catch (e) {
      debugPrint(e.toString());
      return;
    } finally {
      this.isTogglingTodoCompletion = false;
    }
  }

  Future<void> _loadTodos() async {
    this.showLoading();
    try {
      this._todos = await this._todosService.getAllTodos();
    } catch (e) {
      debugPrint(e.toString());
      return;
    } finally {
      this.hideLoading();
    }
  }
}
