import 'package:example/pages/todos/todos_page_state.dart';
// import 'package:example/pages/todos/widgets/todo_tile/todo_tile.dart';
import 'package:example/pages/todos/widgets/todo_tile_keep_alive/todo_tile_keep_alive.dart';
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
      return Container(
        child: Text(
          "No todos added yet :(",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );

    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemCount: this.state.todos.length,
      itemBuilder: (context, index) => this._buildListTile(this.state.todos[index]),
    );
  }

  Widget _buildListTile(Todo todo) {
    // return TodoTile(
    //   todo: todo,
    //   onEditTodoPressed: () => this.state.onEditTodoPressed(todo),
    //   onTodoPressed: () => this.state.onTodoPressed(todo),
    //   toggleCompletionForTodo: () => this.state.toggleCompletionForTodo(todo),
    // );

    return TodoTileKeepAlive(
      todo: todo,
      onEditTodoPressed: () => this.state.onEditTodoPressed(todo),
      toggleCompletionForTodo: () => this.state.toggleCompletionForTodo(todo),
    );
  }
}
