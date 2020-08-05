import 'package:example/pages/manage_todo/services/todo_management_service/todo_management_service.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:floater/floater.dart';
import 'manage_todo_page.dart';

class ManageTodoPageState extends WidgetStateBase<ManageTodoPage> {
  ServiceLocator _scope;
  ServiceLocator get scope => this._scope;

  ManageTodoPageState(Todo todo) : super() {
    this._scope = ServiceManager.instance.createScope()
      ..resolve<TodoManagementService>().init(todo);
  }
}
