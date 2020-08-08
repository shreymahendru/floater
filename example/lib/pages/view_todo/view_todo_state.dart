import 'package:example/pages/view_todo/view_todo.dart';
import 'package:floater/floater.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:example/pages/routes.dart';

class ViewTodoState extends WidgetStateBase<ViewTodo> {
  bool _isTogglingTodoCompletion = false;
  bool get isTogglingTodoCompletion => this._isTogglingTodoCompletion;
  set isTogglingTodoCompletion(bool value) =>
      (this.._isTogglingTodoCompletion = value).triggerStateChange();
  final _navigator = NavigationService.instance.retrieveNavigator("/");

  ViewTodoState(Todo todo) : super() {
    this.onInitState(() {});
  }

  void back() {
    this._navigator.pop();
  }

  Future<void> onEditTodoPressed(Todo todo) async {
    given(todo, "todo").ensureHasValue();
    this._navigator.pushNamed(
      NavigationService.instance.generateRoute(Routes.manageTodo),
      arguments: {
        "todo": todo,
      },
    );
  }

  void toggleCompletionForTodo(Todo todo) async {
    given(todo, "todo").ensureHasValue();

    this.isTogglingTodoCompletion = true;
    try {
      await todo.toggleComplete();
    } catch (e) {
      //debugPrint(e.toString());
      return;
    } finally {
      this.isTogglingTodoCompletion = false;
    }
  }
}
