import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class TodoTile extends StatelessWidgetBase {
  final Todo todo;
  final VoidCallback onTodoPressed;
  final VoidCallback toggleCompletionForTodo;
  final VoidCallback onEditTodoPressed;

  TodoTile({
    required this.todo,
    required this.onTodoPressed,
    required this.toggleCompletionForTodo,
    required this.onEditTodoPressed,
  });

  @override
  Widget build(BuildContext context) {
    final description = todo.description;
    return ListTile(
      title: Text(todo.title),
      subtitle: description != null ? Text(description) : null,
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
