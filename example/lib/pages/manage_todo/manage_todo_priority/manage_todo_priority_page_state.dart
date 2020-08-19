import 'package:example/pages/manage_todo/services/todo_management_service/todo_management_service.dart';
import 'package:example/sdk/todo/model/priority.dart';
import 'package:floater/floater.dart';
import '../../routes.dart';
import 'manage_todo_priority_page.dart';

class ManageTodoPriorityPageState
    extends WidgetStateBase<ManageTodoPriorityPage> {
  final _todoManagementService = NavigationService.instance
      .retrieveScope(Routes.manageTodo)
      .resolve<TodoManagementService>();
  final _rootNavigator = NavigationService.instance.retrieveNavigator("/");
  final _scopedNavigator =
      NavigationService.instance.retrieveNavigator(Routes.manageTodo);

  Priority _priority = Priority.Medium;
  Priority get priority => this._priority;
  set priority(Priority value) =>
      (this.._priority = value).triggerStateChange();

  bool get isNewTodo => this._todoManagementService.isNewTodo;

  ManageTodoPriorityPageState() : super() {
    this._priority = this._todoManagementService.priority;
  }

  void back() {
    // using the root navigator since this is the initial route for this navigator.
    this._scopedNavigator.pop();
  }

  void submit() async {
    final priority = this._priority;

    this._todoManagementService.setPriority(priority);

    this.showLoading();
    try {
      await this._todoManagementService.complete();
    } catch (e) {
      //debugPrint(e.toString());
      return;
    } finally {
      this.hideLoading();
    }
    // remove everything from the stack and push the home page
    this._rootNavigator.pushNamedAndRemoveUntil(Routes.todos, (_) => false);
  }
}
