import 'package:example/pages/manage_todo/services/todo_management_service/todo_management_service.dart';
import 'package:example/services/bottom_nav_manager_mixin.dart';
import 'package:floater/floater.dart';
import '../../routes.dart';
import 'manage_todo_title_page.dart';

class ManageTodoTitlePageState extends WidgetStateBase<ManageTodoTitlePage>
    with BottomNavManagerMixin {
  final _todoManagementService =
      NavigationService.instance.retrieveScope(Routes.manageTodo).resolve<TodoManagementService>();
  // final _rootNavigator = NavigationService.instance.retrieveNavigator("/");
  final _scopedNavigator = NavigationService.instance.retrieveNavigator(Routes.manageTodo);

  late String _title;
  String get title => this._title;
  set title(String value) => (this.._title = value).triggerStateChange();

  bool get isNewTodo => this._todoManagementService.isNewTodo;

  late Validator<ManageTodoTitlePageState> _validator;
  bool get hasErrors => this._validator.hasErrors;
  ValidationErrors get errors => this._validator.errors;

  ManageTodoTitlePageState() : super() {
    this._title = this._todoManagementService.title ?? "";
    this._createValidator();
    this.onStateChange(() {
      // this function is called every time state is about to change, hence best place to run our validation
      this._validate();
    });
  }

  void back() {
    // using the root navigator since this is the initial route for this navigator.
    this.currentNavigator.pop();
  }

  void submit() {
    this._validator.enable();
    if (!this._validate()) {
      this.triggerStateChange();
      return;
    }

    this._todoManagementService.setTitle(this._title);
    this._scopedNavigator.pushNamed(Routes.manageTodoDescription);
  }

  bool _validate() {
    this._validator.validate(this);
    return this._validator.isValid;
  }

  void _createValidator() {
    this._validator = Validator(disabled: true);

    this
        ._validator
        .prop("title", (t) => t.title)
        .isRequired()
        .withMessage(message: "Title is required")
        .hasMaxLength(50)
        .withMessage(message: "Title should be less than 50 characters.");
  }
}
