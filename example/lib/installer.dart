import 'package:example/pages/create_todo/services/todo_creation_service/todo_creation_service.dart';
import 'package:example/sdk/todo/services/todos_service/mock_todos_service.dart';
import 'package:example/sdk/todo/services/todos_service/todos_service.dart';
import 'package:floater/floater.dart';

class Installer extends ServiceInstaller {
  @override
  void install(ServiceRegistry registry) {
    given(registry, "registry").ensureHasValue();

    // Network Services
    // you can change the MockTodoService with RemoteTodoService (which makes the call to an api) without changing any part of your code.
    // it is a Singleton, so there will be only one instance of TodoService through out the lifecycle if the app.
    registry.registerSingleton<TodosService>(() => MockTodosService());

    // ui Services
    // services that facilitate clean communication between pages and/or widgets
    // these services are usually scoped 
    registry.registerScoped<TodoCreationService>(() => TodoCreationService());
  }
}
