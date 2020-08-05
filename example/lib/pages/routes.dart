import 'package:example/pages/manage_todo/manage_todo_description/manage_todo_description_page.dart';
import 'package:example/pages/manage_todo/manage_todo_page.dart';
import 'package:example/pages/manage_todo/manage_todo_title/manage_todo_title_page.dart';
import 'package:example/pages/todos/todos_page.dart';
import 'package:floater/floater.dart';
import 'package:example/pages/splash/splash_page.dart';

abstract class Routes {
  static const splash = "/splash";
  static const todos = "/todos";
  static const manageTodo = "/manageTodo?{todo?: object}";
  static const manageTodoTitle = "/manageTodo/title?{todo?: object}";
  static const manageTodoDescription = "/manageTodo/description";

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
      ..registerPage(Routes.manageTodo, (routeArgs) => ManageTodoPage(routeArgs["todo"]))
      ..registerPage(Routes.manageTodoTitle, (routeArgs) => ManageTodoTitlePage(routeArgs["todo"]))
      ..registerPage(Routes.manageTodoDescription, (routeArgs) => ManageTodoDescriptionPage());

    // bootstrapping Navigation
    NavigationManager.instance.bootstrap();
  }
}
