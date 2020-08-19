import 'package:example/sdk/todo/model/priority.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';
import 'manage_todo_priority_page_state.dart';

class ManageTodoPriorityPage
    extends StatefulWidgetBase<ManageTodoPriorityPageState> {
  ManageTodoPriorityPage() : super(() => ManageTodoPriorityPageState());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${this.state.isNewTodo ? 'New' : 'Edit'} Todo Priority"),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: this.state.back,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButton<Priority>(
                    value: this.state.priority,
                    onChanged: (v) => this.state.priority = v,
                    items: Priority.values.map((Priority priority) {
                      return DropdownMenuItem<Priority>(
                        value: priority,
                        child: Text(priority.toString().split('.').last),
                      );
                    }).toList()),
                SizedBox(height: 30),
                RaisedButton(
                  onPressed: this.state.submit,
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Text(this.state.isNewTodo ? "Create" : "Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
