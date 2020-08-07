import 'view_todo_state.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';
import 'package:example/sdk/todo/proxies/todo.dart';

class ViewTodo extends StatefulWidgetBase<ViewTodoState> {
  final Todo todo;
  ViewTodo(this.todo) : super(() => ViewTodoState(todo));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("View Todo"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => this.state.onEditTodoPressed(todo),
        child: Icon(Icons.edit),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20.0),
          ListTile(
            leading: IconButton(
              icon: Icon(
                todo.isComplete ? Icons.done : Icons.close,
                color: todo.isComplete ? Colors.greenAccent : Colors.redAccent,
                size: 40.0,
              ),
              onPressed: () => this.state.toggleCompletionForTodo(todo),
            ),
            title: Text(
              todo.title,
              style: TextStyle(fontSize: 30),
            ),
          ),
          ListTile(
            leading: Icon(Icons.comment),
            title: Text(todo.description == null ? "" : todo.description),
          ),
          ListTile(
            leading: Icon(Icons.priority_high),
            title: Text(todo.priority == null
                ? "Medium priority"
                : todo.priority + ' priority'),
          ),
          ListTile(
            leading: Icon(Icons.donut_large),
            title: Text(todo.isComplete ? 'Completed' : 'Pending'),
          )
        ],
      ),
    );
  }
}