import 'package:example/pages/create_todo/create_todo_page.dart';
import 'package:example/pages/create_todo/create_todo_title/create_todo_title_page.dart';
import 'package:example/pages/todos/todos_page.dart';
import 'package:floater/floater.dart';
import 'package:example/pages/splash/splash_page.dart';
import 'create_todo/create_todo_description/create_todo_description_page.dart';

abstract class Routes {
  static const splash = "/splash";
  static const todos = "/todos";
  static const createTodo = "/createTodo?{todo?: object}";
  static const createTodoTitle = "/createTodo/title?{todo?: object}";
  static const createTodoDescription = "/createTodo/description";

  static const viewTodo = "/viewTodo";

  // Call this function in main.dart to register all the app pages
  // and bootstrap the navigation
  static void initializeNavigation() {
    // registering app pages here.
    NavigationManager.instance
      ..registerPage(Routes.splash, (routeArgs) => SplashPage())
      ..registerPage(Routes.todos, (routeArgs) => TodosPage());

    // create todo flow
    NavigationManager.instance
      ..registerPage(Routes.createTodo, (routeArgs) => CreateTodoPage(routeArgs["todo"]))
      ..registerPage(Routes.createTodoTitle, (routeArgs) => CreateTodoTitlePage(routeArgs["todo"]))
      ..registerPage(Routes.createTodoDescription, (routeArgs) => CreateTodoDescriptionPage());

    // bootstrapping Navigation
    NavigationManager.instance.bootstrap();
  }
}
