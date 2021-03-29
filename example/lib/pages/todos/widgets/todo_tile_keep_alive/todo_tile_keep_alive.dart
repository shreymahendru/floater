import 'package:example/pages/todos/widgets/todo_tile_keep_alive/todo_tile_keep_alive_state.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class TodoTileKeepAlive extends StatefulWidgetBase<TodoTileKeepAliveState> {
  final VoidCallback toggleCompletionForTodo;
  final VoidCallback onEditTodoPressed;

  TodoTileKeepAlive({
    required Todo todo,
    required this.toggleCompletionForTodo,
    required this.onEditTodoPressed,
  }) : super(() => TodoTileKeepAliveState(todo));

  @override
  Widget build(BuildContext context) {
    final todo = this.state.todo;
    final title = todo.title;
    final description = todo.description;
    return ListTile(
      tileColor: this.state.isClicked ? Colors.teal : Colors.white,
      title: Text(title),
      subtitle: description != null ? Text(description) : null,
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
