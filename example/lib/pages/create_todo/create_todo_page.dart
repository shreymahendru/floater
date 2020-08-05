import 'package:example/pages/routes.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class CreateTodoPage extends StatelessWidgetBase {
  final Todo _todo;

  CreateTodoPage(this._todo);

  @override
  Widget build(BuildContext context) {
    return ScopedNavigator(
      Routes.createTodo,
      initialRoute: NavigationService.instance.generateRoute(Routes.createTodoTitle),
      initialRouteArgs: {
        "todo": this._todo,
      },
    );
  }
}
