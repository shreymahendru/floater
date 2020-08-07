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
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        this.state.onSwipeDelete(todo);
      },
      child: ListTile(
        title: Text(todo.title),
        //subtitle: Text(todo.priority),
        subtitle: todo.description != null ? Text(todo.description) : null,
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
    );
  }
}
