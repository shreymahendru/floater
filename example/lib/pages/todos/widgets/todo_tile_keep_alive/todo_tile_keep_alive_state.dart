import 'package:example/pages/todos/widgets/todo_tile_keep_alive/todo_tile_keep_alive.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:floater/floater.dart';

class TodoTileKeepAliveState extends AutomaticKeepAliveWidgetStateBase<TodoTileKeepAlive> {
  final Todo todo;

  bool _isClicked = false;
  bool get isClicked => this._isClicked;
  set isClicked(bool v) => (this.._isClicked = v)..triggerStateChange();

  TodoTileKeepAliveState(this.todo) : super() {
    this.onInitState(() {
      print("init-ing ${todo.title}");
      this.wantKeepAlive = false;
    });

    this.onDispose(() {
      print("disposing ${todo.title}");
    });
  }

  void onTodoPressed() {
    this.isClicked = !this.isClicked;
    this.wantKeepAlive = !this.wantKeepAlive;
  }
}
