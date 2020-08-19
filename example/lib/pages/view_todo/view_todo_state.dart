import 'package:example/pages/view_todo/view_todo.dart';
import 'package:floater/floater.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:example/pages/routes.dart';
import 'package:flutter/foundation.dart';

class ViewTodoState extends WidgetStateBase<ViewTodo> {
  final _navigator = NavigationService.instance.retrieveNavigator("/");

  Todo _todo;
  Todo get todo => this._todo;

  ViewTodoState(Todo todo) : super() {
    this._todo = todo;
  }

  void back() {
    this._navigator.pop();
  }

  Future<void> onEditTodoPressed() async {
    this._navigator.pushNamed(
      NavigationService.instance.generateRoute(Routes.manageTodo),
      arguments: {
        "todo": todo,
      },
    );
  }

  void toggleCompletionForTodo() async {
    this.showLoading();
    try {
      await todo.toggleComplete();
    } catch (e) {
      debugPrint(e.toString());
      return;
    } finally {
      this.hideLoading();
    }
  }
}
