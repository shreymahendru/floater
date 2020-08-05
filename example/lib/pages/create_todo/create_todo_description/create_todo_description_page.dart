import 'package:example/pages/create_todo/create_todo_description/create_todo_description_page_state.dart';
import 'package:example/widgets/overlay_loading_spinner/overlay_loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class CreateTodoDescriptionPage extends StatefulWidgetBase<CreateTodoDescriptionPageState> {
  CreateTodoDescriptionPage() : super(() => CreateTodoDescriptionPageState());
  @override
  Widget build(BuildContext context) {
    return OverlayLoadingSpinner(
      isEnabled: this.state.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Todo Description"),
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
                  initialValue: this.state.description,
                  onChanged: (v) => this.state.description = v,
                  maxLines: 10,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: "Description (optional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    errorText: this.state.errors.getError("description"),
                  ),
                ),
                SizedBox(height: 30),
                RaisedButton(
                  onPressed: this.state.hasErrors ? null : this.state.submit,
                  child: Text("Create"),
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
