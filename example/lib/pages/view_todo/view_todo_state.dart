import 'package:example/pages/view_todo/view_todo_page.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:example/sdk/todo/services/todos_service/todos_service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class ViewTodoPageState extends WidgetStateBase<ViewTodoPage> {
  final _todoService = ServiceLocator.instance.resolve<TodosService>();
  final _navigator = NavigationService.instance.retrieveNavigator("/");

  final String _id;
  Todo todo;

  ViewTodoPageState(this._id) : super() {
    this.onInitState(() {
      this._init();
    });
  }

  Future<void> _init() async {
    this.showLoading();
    try {
      this.todo = await this._todoService.getTodo(this._id);
    } catch (e) {
      debugPrint(e);
      this._navigator.pop();
    } finally {
      this.hideLoading();
    }
  }
}
