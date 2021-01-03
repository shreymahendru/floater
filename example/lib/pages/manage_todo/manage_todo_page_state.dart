import 'package:example/pages/manage_todo/services/todo_management_service/todo_management_service.dart';
import 'package:floater/floater.dart';
import 'manage_todo_page.dart';

class ManageTodoPageState extends WidgetStateBase<ManageTodoPage> {
  ServiceLocator _scope;
  ServiceLocator get scope => this._scope;

  bool _isServiceInitialized = false;
  bool get isServiceInitialized => this._isServiceInitialized;
  set isServiceInitialized(bool value) =>
      (this.._isServiceInitialized = value).triggerStateChange();

  ManageTodoPageState(String id) : super() {
    this._scope = ServiceManager.instance.createScope();
    print("asd");
    this
        ._scope
        .resolve<TodoManagementService>()
        .init(id)
        .then((_) => this.isServiceInitialized = true);
  }
}
