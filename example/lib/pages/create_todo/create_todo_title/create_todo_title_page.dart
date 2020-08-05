import 'package:example/pages/create_todo/create_todo_title/create_todo_title_page_state.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class CreateTodoTitlePage extends StatefulWidgetBase<CreateTodoTitlePageState> {
  CreateTodoTitlePage(Todo todo) : super(() => CreateTodoTitlePageState(todo));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Todo Title"),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: this.state.back,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                initialValue: this.state.title,
                onChanged: (v) => this.state.title = v,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorText: this.state.errors.getError("title"),
                ),
              ),
              SizedBox(height: 30),
              RaisedButton(
                onPressed: this.state.hasErrors ? null : this.state.submit,
                child: Text("Next"),
                color: Colors.blueAccent,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
