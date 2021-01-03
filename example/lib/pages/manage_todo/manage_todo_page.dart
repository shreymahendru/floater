import 'package:example/pages/routes.dart';
import 'package:example/widgets/loading_spinner/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';
import 'manage_todo_page_state.dart';

class ManageTodoPage extends StatefulWidgetBase<ManageTodoPageState> {
  ManageTodoPage(String id) : super(() => ManageTodoPageState(id));
  @override
  Widget build(BuildContext context) {
    return this.state.isServiceInitialized
        ? ScopedNavigator(
            Routes.manageTodo,
            initialRoute: Routes.manageTodoTitle,
            scope: this.state.scope,
          )
        : this._buildLoadingScreen();
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        child: SizedBox.expand(
          child: Container(
            alignment: Alignment.center,
            child: LoadingSpinner(),
          ),
        ),
      ),
    );
  }
}
