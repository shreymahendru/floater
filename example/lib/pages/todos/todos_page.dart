import 'package:example/pages/todos/todos_page_state.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:example/widgets/loading_spinner/loading_spinner.dart';
import 'package:example/widgets/overlay_loading_spinner/overlay_loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class TodosPage extends StatefulWidgetBase<TodosPageState> {
  TodosPage() : super(() => TodosPageState());
  @override
  Widget build(BuildContext context) {
    return OverlayLoadingSpinner(
      isEnabled: this.state.isTogglingTodoCompletion,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Todos"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: this.state.onAddTodoPressed,
          child: Icon(Icons.add),
        ),
        body: this._buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (this.state.isLoading)
      return Container(
        child: Center(
          child: LoadingSpinner(),
        ),
      );

    if (this.state.todos.isEmpty)
      return Center(
        child: Text(
          "No todos added yet :(",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );

    return ListView.builder(
      itemCount: this.state.todos.length,
      itemBuilder: (context, index) =>
          this._buildListTile(this.state.todos[index]),
    );
  }

  Widget _buildListTile(Todo todo) {
    return Dismissible(
      onDismissed: (direction) => this.state.onSwipeDelete(todo),
      key: Key(todo.id),
      background: onSlideLeft(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: ListTile(
            title: Text(todo.title),
            subtitle:
                todo.description != null ? Text(todo.description) : Text(" "),
            dense: true,
            onTap: () => this.state.onTodoPressed(todo),
            leading: IconButton(
              icon: Icon(
                todo.isComplete ? Icons.done : Icons.close,
                color: todo.isComplete ? Colors.greenAccent : Colors.redAccent,
              ),
              onPressed: () => this.state.toggleCompletionForTodo(todo),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.black,
              ),
              onPressed: () => this.state.onEditTodoPressed(todo),
            ),
          ),
        ),
      ),
    );
  }

  Widget onSlideLeft() {
    return Expanded(
      child: Container(
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.delete, color: Colors.red),
              Text(
                " Delete",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
