import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class TodoTile extends StatelessWidgetBase {
  final Todo todo;
  final VoidCallback onTodoPressed;
  final VoidCallback toggleCompletionForTodo;
  final VoidCallback onEditTodoPressed;

  TodoTile({
    this.todo,
    this.onTodoPressed,
    this.toggleCompletionForTodo,
    this.onEditTodoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.title),
      subtitle: todo.description != null ? Text(todo.description) : null,
      dense: true,
      onTap: this.onTodoPressed,
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
