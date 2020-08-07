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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                DropdownButton<String>(
                  value:
                      this.state.priority == null || this.state.priority.isEmpty
                          ? "Medium"
                          : this.state.priority,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  onChanged: (v) => this.state.priority = v,
                  items: <String>['High', 'Medium', 'Low']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 30),
                RaisedButton(
                  onPressed: this.state.submit,
                  child: Text(this.state.isNewTodo ? "Create" : "Update"),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
