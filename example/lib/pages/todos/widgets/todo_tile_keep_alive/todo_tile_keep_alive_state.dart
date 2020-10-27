import 'package:example/events/todo_updated_event.dart';
import 'package:example/pages/todos/widgets/todo_tile_keep_alive/todo_tile_keep_alive.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:floater/floater.dart';

class TodoTileKeepAliveState extends KeepAliveClientWidgetStateBase<TodoTileKeepAlive> {
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();

  final Todo todo;

  bool _isClicked = false;
  bool get isClicked => this._isClicked;
  set isClicked(bool v) => (this.._isClicked = v)..triggerStateChange();

  TodoTileKeepAliveState(this.todo) : super() {
    this.onInitState(() {
      this.wantKeepAlive = false;
    });

    this.watch<TodoUpdatedEvent>(this._eventAggregator.subscribe<TodoUpdatedEvent>(), (event) {
      if (event.todo.id == this.todo.id) {
        this.triggerStateChange();
      }
    });
  }

  void onTodoPressed() {
    this.isClicked = !this.isClicked;
    this.wantKeepAlive = !this.wantKeepAlive;
  }
}
