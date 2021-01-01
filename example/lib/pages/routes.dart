import 'package:example/pages/manage_todo/manage_todo_description/manage_todo_description_page.dart';
import 'package:example/pages/manage_todo/manage_todo_page.dart';
import 'package:example/pages/manage_todo/manage_todo_title/manage_todo_title_page.dart';
import 'package:example/pages/todos/todos_page.dart';
import 'package:example/pages/view_todo/view_todo_page.dart';
import 'package:floater/floater.dart';
import 'package:example/pages/splash/splash_page.dart';

abstract class Routes {
  static const splash = "/splash";
  static const todos = "/todos";
  static const manageTodo = "/manageTodo?{id?: string}";
  static const manageTodoTitle = "/manageTodo/title";
  static const manageTodoDescription = "/manageTodo/description";

  static const viewTodo = "/viewTodo?{id: string}";

  // Call this function in main.dart to register all the app pages
  // and bootstrap the navigation
  static void initializeNavigation() {
    // registering app pages here.
    // root nav pages
    NavigationManager.instance
      ..registerPage(Routes.splash, (routeArgs) => SplashPage())
      ..registerPage(Routes.todos, (routeArgs) => TodosPage());

    // manage todo flow pages
    NavigationManager.instance
      ..registerPage(Routes.manageTodo, (routeArgs) => ManageTodoPage(routeArgs["id"]), persist: true)
      ..registerPage(Routes.manageTodoTitle, (routeArgs) => ManageTodoTitlePage())
      ..registerPage(Routes.manageTodoDescription, (routeArgs) => ManageTodoDescriptionPage());

    NavigationManager.instance
      ..registerPage(Routes.viewTodo, (routeArgs) => ViewTodoPage(routeArgs["id"]));
    // bootstrapping Navigation
    NavigationManager.instance.bootstrap();
  }
}
