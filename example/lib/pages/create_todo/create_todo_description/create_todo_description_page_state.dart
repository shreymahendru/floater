import 'package:example/pages/create_todo/create_todo_description/create_todo_description_page.dart';
import 'package:example/pages/create_todo/services/todo_creation_service/todo_creation_service.dart';
import 'package:example/pages/routes.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class CreateTodoDescriptionPageState extends WidgetStateBase<CreateTodoDescriptionPage> {
  final _todoCreationService =
      NavigationService.instance.retrieveScope(Routes.createTodo).resolve<TodoCreationService>();
  final _rootNavigator = NavigationService.instance.retrieveNavigator("/");
  final _scopedNavigator = NavigationService.instance.retrieveNavigator(Routes.createTodo);

  String _description;
  String get description => this._description;
  set description(String value) => (this.._description = value).triggerStateChange();

  Validator<CreateTodoDescriptionPageState> _validator;
  bool get hasErrors => this._validator.hasErrors;
  ValidationErrors get errors => this._validator.errors;

  CreateTodoDescriptionPageState() : super() {
    this._description = this._todoCreationService.description;
    this._createValidator();
    this.onStateChange(() {
      this._validate();
    });
  }

  void back() {
    // using the root navigator since this is the initial route for this navigator.
    this._scopedNavigator.pop();
  }

  void submit() async {
    this._validator.enable();
    if (!this._validate()) {
      this.triggerStateChange();
      return;
    }

    if (this._description != null && this._description.isNotEmpty)
      this._todoCreationService.setDescription(this._description);

    this.showLoading();
    try {
      await this._todoCreationService.complete();
    } catch (e) {
      debugPrint(e.toString());
      return;
    } finally {
      this.hideLoading();
    }

    // remove everything from the stack and push the home page
    this._rootNavigator.pushNamedAndRemoveUntil(Routes.todos, (_) => false);
  }

  bool _validate() {
    this._validator.validate(this);
    return this._validator.isValid;
  }

  void _createValidator() {
    this._validator = Validator(disabled: true);

    this
        ._validator
        .prop("description", (t) => t.description)
        .isOptional()
        .hasMaxLength(500)
        .withMessage(message: "Description should be less than 500 characters.");
  }
}
