import 'package:example/pages/manage_todo/services/todo_management_service/todo_management_service.dart';
import 'package:example/pages/routes.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';
import 'manage_todo_description_page.dart';

class ManageTodoDescriptionPageState extends WidgetStateBase<ManageTodoDescriptionPage> {
  final _todoManagementService =
      NavigationService.instance.retrieveScope(Routes.manageTodo).resolve<TodoManagementService>();
  final _rootNavigator = NavigationService.instance.retrieveNavigator("/");
  final _scopedNavigator = NavigationService.instance.retrieveNavigator(Routes.manageTodo);

  String? _description;
  String? get description => this._description;
  set description(String? value) => (this.._description = value).triggerStateChange();

  bool get isNewTodo => this._todoManagementService.isNewTodo;

  late Validator<ManageTodoDescriptionPageState> _validator;
  bool get hasErrors => this._validator.hasErrors;
  ValidationErrors get errors => this._validator.errors;

  ManageTodoDescriptionPageState() : super() {
    this._description = this._todoManagementService.description;
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

    final String? description;
    if (this._description == null)
      description = null;
    else
      description = this._description!.trim().isEmpty ? null : this._description!.trim();

    this._todoManagementService.setDescription(description);

    this.showLoading();
    try {
      await this._todoManagementService.complete();
    } catch (e) {
      debugPrint(e.toString());
      return;
    } finally {
      this.hideLoading();
    }

    this._rootNavigator.pop();
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
