import 'package:example/widgets/loading_spinner/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';
import 'view_todo_state.dart';

class ViewTodoPage extends StatefulWidgetBase<ViewTodoPageState> {
  ViewTodoPage(String id) : super(() => ViewTodoPageState(id));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("View Todo"),
      ),
      body: this._buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (this.state.isLoading)
      return Container(
        child: Center(
          child: LoadingSpinner(),
        ),
      );    

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            this.state.todo.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            this.state.todo.description,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
