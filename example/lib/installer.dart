import 'package:example/pages/manage_todo/services/todo_management_service/todo_management_service.dart';
import 'package:example/sdk/todo/services/todos_service/mock_todos_service.dart';
import 'package:example/sdk/todo/services/todos_service/todos_service.dart';
import 'package:example/services/bottom_nav_manager.dart';
import 'package:floater/floater.dart';

class Installer extends ServiceInstaller {
  @override
  void install(ServiceRegistry registry) {
    // Network Services
    // you can change the MockTodoService with RemoteTodoService (which makes the call to an api) without changing any part of your code.
    // it is a Singleton, so there will be only one instance of TodoService through out the lifecycle if the app.
    registry.registerSingleton<TodosService>(() => MockTodosService());


    // ui Services
    // services that facilitate clean communication between pages and/or widgets
    // these services are usually scoped
    registry.registerScoped<TodoManagementService>(() => TodoManagementService());
    registry.registerSingleton<BottomNavManager>(() => BottomNavManager());
  }
}
