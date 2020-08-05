import 'package:example/pages/routes.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';
import 'manage_todo_page_state.dart';

class ManageTodoPage extends StatefulWidgetBase<ManageTodoPageState> {
  ManageTodoPage(Todo todo) : super(() => ManageTodoPageState(todo));
  @override
  Widget build(BuildContext context) {
    return ScopedNavigator(
      Routes.manageTodo,
      initialRoute: Routes.manageTodoTitle,
      scope: this.state.scope,
    );
  }
}
