import 'package:example/pages/todos/widgets/todo_tile_keep_alive/todo_tile_keep_alive_state.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class TodoTileKeepAlive extends StatefulWidgetBase<TodoTileKeepAliveState> {
  final VoidCallback toggleCompletionForTodo;
  final VoidCallback onEditTodoPressed;

  TodoTileKeepAlive({
    Todo todo,
    this.toggleCompletionForTodo,
    this.onEditTodoPressed,
  }) : super(() => TodoTileKeepAliveState(todo));

  @override
  Widget build(BuildContext context) {
    final todo = this.state.todo;
    return ListTile(
      tileColor: this.state.isClicked ? Colors.teal : Colors.white,
      title: Text(todo.title),
      subtitle: todo.description != null ? Text(todo.description) : null,
      dense: true,
      onTap: this.state.onTodoPressed,
      leading: IconButton(
        icon: Icon(
          todo.isComplete ? Icons.done : Icons.close,
          color: todo.isComplete ? Colors.greenAccent : Colors.redAccent,
        ),
        onPressed: this.toggleCompletionForTodo,
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.edit,
          color: Colors.black,
        ),
        onPressed: this.onEditTodoPressed,
      ),
    );
  }
}
