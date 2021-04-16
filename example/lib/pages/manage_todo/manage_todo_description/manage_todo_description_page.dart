import 'package:example/widgets/overlay_loading_spinner/overlay_loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';
import 'manage_todo_description_page_state.dart';

class ManageTodoDescriptionPage extends StatefulWidgetBase<ManageTodoDescriptionPageState> {
  ManageTodoDescriptionPage() : super(() => ManageTodoDescriptionPageState());
  @override
  Widget build(BuildContext context) {
    return OverlayLoadingSpinner(
      isEnabled: this.state.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${this.state.isNewTodo ? 'New' : 'Edit'} Todo Description"),
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
                    errorText: this.state.errors.getError("description") as String?,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: this.state.hasErrors ? null : this.state.submit,
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
