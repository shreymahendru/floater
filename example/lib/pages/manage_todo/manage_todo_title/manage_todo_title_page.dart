import 'package:flutter/material.dart';
import 'package:floater/floater.dart';
import 'manage_todo_title_page_state.dart';

class ManageTodoTitlePage extends StatefulWidgetBase<ManageTodoTitlePageState> {
  ManageTodoTitlePage() : super(() => ManageTodoTitlePageState());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${this.state.isNewTodo ? 'New' : 'Edit'} Todo Title"),
        backgroundColor: this.state.appBarColor,
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
              ElevatedButton(
                onPressed: this.state.hasErrors ? null : this.state.submit,
                child: Text("Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
