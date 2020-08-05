import 'package:example/pages/create_todo/services/todo_creation_service/todo_creation_service.dart';
import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:floater/floater.dart';
import '../../routes.dart';
import 'create_todo_title_page.dart';

class CreateTodoTitlePageState extends WidgetStateBase<CreateTodoTitlePage> {
  final _todoCreationService =
      NavigationService.instance.retrieveScope(Routes.createTodo).resolve<TodoCreationService>();
  final _rootNavigator = NavigationService.instance.retrieveNavigator("/");
  final _scopedNavigator = NavigationService.instance.retrieveNavigator(Routes.createTodo);

  String _title;
  String get title => this._title;
  set title(String value) => (this.._title = value).triggerStateChange();

  Validator<CreateTodoTitlePageState> _validator;
  bool get hasErrors => this._validator.hasErrors;
  ValidationErrors get errors => this._validator.errors;

  CreateTodoTitlePageState(Todo todo) : super() {
    // init-ing the scoped service
    this._todoCreationService.init(todo);

    this._title = this._todoCreationService.title;

    this._createValidator();
    this.onStateChange(() {
      this._validate();
    });
  }

  void back() {
    // using the root navigator since this is the initial route for this navigator.
    this._rootNavigator.pop();
  }

  void submit() {
    this._validator.enable();
    if (!this._validate()) {
      this.triggerStateChange();
      return;
    }

    this._todoCreationService.setTitle(this._title);
    this._scopedNavigator.pushNamed(Routes.createTodoDescription);
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
