import 'package:example/pages/routes.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class ManageTodoPage extends StatelessWidgetBase {
  final Todo _todo;

  ManageTodoPage(this._todo);

  @override
  Widget build(BuildContext context) {
    return ScopedNavigator(
      Routes.manageTodo,
      initialRoute: NavigationService.instance.generateRoute(Routes.manageTodoTitle),
      initialRouteArgs: {
        "todo": this._todo,
      },
    );
  }
}
