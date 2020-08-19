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
    return Stack(
      children: <Widget>[
        Positioned.fill(child: this._buildBackground()),
        Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => this.state.onSwipeDelete(todo),
          dismissThresholds: const {
            DismissDirection.endToStart: 0.6,
          },
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: ListTile(
              title: Text(todo.title),
              subtitle:
                  todo.description != null ? Text(todo.description) : null,
              dense: true,
              onTap: () => this.state.onTodoPressed(todo),
              leading: IconButton(
                icon: Icon(
                  todo.isComplete ? Icons.done : Icons.close,
                  color:
                      todo.isComplete ? Colors.greenAccent : Colors.redAccent,
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
        )
      ],
    );
  }

  Widget _buildBackground() {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
